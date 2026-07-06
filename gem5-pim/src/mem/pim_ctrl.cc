#include "mem/pim_ctrl.hh"
#include "mem/mem_ctrl.hh"

namespace gem5
{
namespace memory
{

PIMCtrl::PIMCtrl(const PIMCtrlParams &p) : MemCtrl(p), pim_stats(*this)
{
    // Make sure that the dram interface is actually a PIMInterface
    pim_intr = dynamic_cast<PIMInterface *>(p.dram);
    assert(pim_intr != nullptr);
    DPRINTF(PIMCtrl, "Initialized PIMCtrl\n");
}

Tick
PIMCtrl::recvAtomic(PacketPtr pkt)
{
    if (!dram->getAddrRange().contains(pkt->getAddr())) {
        panic("Can't handle address range for packet %s\n", pkt->print());
    }
    DPRINTF(PIMCtrl, "recvAtomic: %s 0x%x\n", pkt->cmdString(),
            pkt->getAddr());

    panic_if(pkt->cacheResponding(), "Should not see packets where cache "
                                     "is responding");

    // do the actual memory access and turn the packet into a response
    pim_intr->access(pkt);

    if (pkt->hasData()) {
        // this value is not supposed to be accurate, just enough to
        // keep things going, mimic a closed page
        // also this latency can't be 0
        return pim_intr->accessLatency();
    }

    return 0;
}

void
PIMCtrl::accessAndRespond(PacketPtr pkt, Tick static_latency,
                          MemInterface *mem_intr)
{
    DPRINTF(PIMCtrl, "Responding to Address %#x.. \n", pkt->getAddr());

    bool needsResponse = pkt->needsResponse();
    // do the actual memory access which also turns the packet into a
    // response
    panic_if(!mem_intr->getAddrRange().contains(pkt->getAddr()),
             "Can't handle address range for packet %s\n", pkt->print());

    PIMInterface *pim_intr = dynamic_cast<PIMInterface *>(mem_intr);
    assert(pim_intr != nullptr);
    if(pim_intr->inPIMMode()){
        static_latency -= backendLatency; // remove the backend latency from the static latency since the response is instant
    }
    // do the actual memory access and turn the packet into a response
    pim_intr->access(pkt);

    // turn packet around to go back to requestor if response expected
    if (needsResponse) {
        // access already turned the packet into a response
        assert(pkt->isResponse());
        // response_time consumes the static latency and is charged also
        // with headerDelay that takes into account the delay provided by
        // the xbar and also the payloadDelay that takes into account the
        // number of data beats.
        Tick response_time =
            curTick() + static_latency + pkt->headerDelay + pkt->payloadDelay;
        // Here we reset the timing of the packet before sending it out.
        pkt->headerDelay = pkt->payloadDelay = 0;

        // queue the packet in the response queue to be sent out after
        // the static latency has passed
        port.schedTimingResp(pkt, response_time);
    } else {
        // @todo the packet is going to be deleted, and the MemPacket
        // is still having a pointer to it
        pendingDelete.reset(pkt);
    }

    DPRINTF(PIMCtrl, "Done\n");

    return;
}


/*
bool
PIMCtrl::recvTimingReq(PacketPtr pkt)
{
    PIMInterface *pim_intr = dynamic_cast<PIMInterface *>(dram);
    assert(pim_intr != nullptr);
    if (pim_intr->inPIMMode()) {
        MemPacket *mem_pkt = pim_intr->decodePacket(
            pkt, pkt->getAddr(), pkt->getSize(), pim_intr->pseudoChannel);
        Tick pim_allowed_at, pim_ends_at;
        std::tie(pim_allowed_at, pim_ends_at) = pim_intr->beginEndNextInstr(mem_pkt, lastFetch);
        lastFetch = pim_allowed_at;
        pipelineEnd = pim_ends_at;
        DPRINTF(PIMCtrl, "recvTimingReq in PIM: request %s addr %#x size %d will start at %d and end at %d\n", pkt->cmdString(),
                pkt->getAddr(), pkt->getSize(), pim_allowed_at, pim_ends_at);
        accessAndRespond(pkt, frontendLatency, pim_intr);
        return true;
    } else {
        return MemCtrl::recvTimingReq(pkt);
    }
}

*/

void
PIMCtrl::addToPIMQueue(PacketPtr pkt)
{
    MemPacket *mem_pkt = pim_intr->decodePacket(
        pkt, pkt->getAddr(), pkt->getSize(), pim_intr->pseudoChannel);
    pim_queue.push_back(mem_pkt);
    DPRINTF(PIMCtrl, "Added packet to PIM queue: %s addr %#x size %d\n",
            pkt->cmdString(), pkt->getAddr(), pkt->getSize());

    accessAndRespond(pkt, frontendLatency, pim_intr);
    // Insert into response queue. It will be sent back to the
    // requestor at its readyTime
    /*/
    if (respQueue.empty()) {
        assert(!respondEvent.scheduled());
        schedule(respondEvent, curTick());
    } else {
        assert(respQueue.back()->readyTime <= mem_pkt->readyTime);
        assert(respondEvent.scheduled());
    }

    respQueue.push_back(mem_pkt);
    
    */
    
}

/*
bool
PIMCtrl::recvTimingReq(PacketPtr pkt)
{
    if(pim_intr->inPIMMode()){
        addToPIMQueue(pkt);
        if (!nextReqEvent.scheduled()) {
            schedule(nextReqEvent, curTick());
        }
        return true;
   }
   else{
        return MemCtrl::recvTimingReq(pkt);
   }
}*/

/*

Tick
PIMCtrl::issuePIM(MemPacket* mem_pkt, MemInterface* mem_intr)
{
    Tick cmd_at;

    std::tie(cmd_at, pim_intr->nextBurstAt) = pim_intr->issuePIM(mem_pkt, mem_intr->nextBurstAt);

    pim_intr->nextReqTime = cmd_at - pim_intr->commandOffset();

    return cmd_at;
}

*/

/*

void
PIMCtrl::processNextReqEvent(MemInterface* mem_intr,
                        MemPacketQueue& resp_queue,
                        EventFunctionWrapper& resp_event,
                        EventFunctionWrapper& next_req_event,
                        bool& retry_wr_req) {
    if(pim_queue.size() > 0 && pim_intr->inPIMMode()){
        MemPacket* mem_pkt = pim_queue.front();
        pim_queue.pop_front();
        Tick cmd_at = issuePIM(mem_pkt, mem_intr);
        DPRINTF(PIMCtrl, "processNextReqEvent in PIM: request %s addr %#x size %d will be issued at %d\n", mem_pkt->pkt->cmdString(),
                mem_pkt->pkt->getAddr(), mem_pkt->pkt->getSize(), cmd_at);
        if (!next_req_event.scheduled())
            schedule(next_req_event, std::max(mem_intr->nextReqTime, curTick()));
    }
    else{
        MemCtrl::processNextReqEvent(mem_intr, resp_queue, resp_event,
                                    next_req_event, retry_wr_req);
    }
}


void
PIMCtrl::processNextReqEvent(MemInterface* mem_intr,
                        MemPacketQueue& resp_queue,
                        EventFunctionWrapper& resp_event,
                        EventFunctionWrapper& next_req_event,
                        bool& retry_wr_req)
{
    if(pim_intr->inPIMMode()){
        Tick oldest_request_time = std::numeric_limits<Tick>::max();
        bool is_read = true;
        for (auto queue = readQueue.rbegin(); queue != readQueue.rend(); ++queue){
            for (auto i = (*queue).begin(); i != (*queue).end(); ++i){
                MemPacket* mem_pkt = *i;
                if(mem_pkt->readyTime < oldest_request_time){
                    oldest_request_time = mem_pkt->readyTime;
                }
            }
        }
        for (auto queue = writeQueue.rbegin(); queue != writeQueue.rend(); ++queue){
            for (auto i = (*queue).begin(); i != (*queue).end(); ++i){
                MemPacket* mem_pkt = *i;
                if(mem_pkt->readyTime < oldest_request_time){
                    oldest_request_time = mem_pkt->readyTime;
                    is_read = false;
                    break;
                }
            }
            if(!is_read){
                break;
            }
        }
        pim_intr->busStateNext = is_read ? MemCtrl::READ : MemCtrl::WRITE;
    }
    MemCtrl::processNextReqEvent(mem_intr, resp_queue, resp_event,
                                next_req_event, retry_wr_req);                    
}

*/

PIMCtrl::PIMCtrlStats::PIMCtrlStats(PIMCtrl &_pim_ctrl)
    : Group(&_pim_ctrl),
      pim_ctrl(_pim_ctrl),
      PIMReads(this, "PIMReads", "Number of PIM read requests"),
      PIMWrites(this, "PIMWrites", "Number of PIM write requests")
{}

} // namespace memory
} // namespace gem5
