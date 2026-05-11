#include "mem/pim_ctrl.hh"

namespace gem5
{
namespace memory
{

PIMCtrl::PIMCtrl(const PIMCtrlParams &p) : MemCtrl(p), pim_stats(*this)
{
    // Make sure that the dram interface is actually a PIMInterface
    assert((dynamic_cast<PIMInterface *>(p.dram) != nullptr));
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

    PIMInterface *pim_intr = dynamic_cast<PIMInterface *>(dram);
    assert(pim_intr != nullptr);
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

bool
PIMCtrl::recvTimingReq(PacketPtr pkt)
{
    // This is where we enter from the outside world
    DPRINTF(PIMCtrl, "recvTimingReq: request %s addr %#x size %d\n",
            pkt->cmdString(), pkt->getAddr(), pkt->getSize());

    panic_if(pkt->cacheResponding(), "Should not see packets where cache "
                                     "is responding");

    panic_if(!(pkt->isRead() || pkt->isWrite()),
             "Should only see read and writes at memory controller\n");

    // Calc avg gap between requests
    if (prevArrival != 0) {
        stats.totGap += curTick() - prevArrival;
    }
    prevArrival = curTick();

    panic_if(!(dram->getAddrRange().contains(pkt->getAddr())),
             "Can't handle address range for packet %s\n", pkt->print());

    PIMInterface *pim_intr = dynamic_cast<PIMInterface *>(dram);
    assert(pim_intr != nullptr);

    // Find out how many memory packets a pkt translates to
    // If the burst size is equal or larger than the pkt size, then a pkt
    // translates to only one memory packet. Otherwise, a pkt translates to
    // multiple memory packets
    unsigned size = pkt->getSize();
    uint32_t burst_size = dram->bytesPerBurst();

    unsigned offset = pkt->getAddr() & (burst_size - 1);
    unsigned int pkt_count = divCeil(offset + size, burst_size);

    // run the QoS scheduler and assign a QoS priority value to the packet
    qosSchedule({&readQueue, &writeQueue}, burst_size, pkt);

    // check local buffers and do not accept if full
    if (pkt->isWrite()) {
        assert(size != 0);
        if (writeQueueFull(pkt_count)) {
            DPRINTF(PIMCtrl, "Write queue full, not accepting\n");
            // remember that we have to retry this port
            retryWrReq = true;
            stats.numWrRetry++;
            return false;
        } else {
            addToWriteQueue(pkt, pkt_count, dram);
            // If we are not already scheduled to get a request out of the
            // queue, do so now
            if (!nextReqEvent.scheduled()) {
                DPRINTF(PIMCtrl, "Request scheduled immediately\n");
                schedule(nextReqEvent, curTick());
            }
            if (pim_intr->inPIMMode()) {
                pim_stats.PIMWrites++;
            } else {

                stats.bytesWrittenSys += size;
                stats.writeReqs++;
            }
        }
    } else {
        assert(pkt->isRead());
        assert(size != 0);
        if (readQueueFull(pkt_count)) {
            DPRINTF(PIMCtrl, "Read queue full, not accepting\n");
            // remember that we have to retry this port
            retryRdReq = true;
            stats.numRdRetry++;
            return false;
        } else {
            if (!addToReadQueue(pkt, pkt_count, dram)) {
                // If we are not already scheduled to get a request out of the
                // queue, do so now
                if (!nextReqEvent.scheduled()) {
                    DPRINTF(PIMCtrl, "Request scheduled immediately\n");
                    schedule(nextReqEvent, curTick());
                }
            }
            if (pim_intr->inPIMMode()) {
                pim_stats.PIMReads++;
            } else {
                stats.readReqs++;
                stats.bytesReadSys += size;
            }
        }
    }

    return true;
}

PIMCtrl::PIMCtrlStats::PIMCtrlStats(PIMCtrl &_pim_ctrl)
    : Group(&_pim_ctrl),
      pim_ctrl(_pim_ctrl),
      PIMReads(this, "PIMReads", "Number of PIM read requests"),
      PIMWrites(this, "PIMWrites", "Number of PIM write requests")
{}

} // namespace memory
} // namespace gem5
