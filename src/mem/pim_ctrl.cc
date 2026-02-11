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

} // namespace memory
} // namespace gem5
