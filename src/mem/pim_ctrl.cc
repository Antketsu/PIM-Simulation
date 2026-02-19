#include "mem/pim_ctrl.hh"

namespace gem5
{
namespace memory
{

PIMCtrl::PIMCtrl(const PIMCtrlParams &p) : MemCtrl(p)
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

} // namespace memory
} // namespace gem5
