#ifndef __PIM_CTRL_HH__
#define __PIM_CTRL_HH__

#include "debug/PIMCtrl.hh"
#include "mem/mem_ctrl.hh"
#include "mem/pim_interface.hh"
#include "params/PIMCtrl.hh"

namespace gem5
{
namespace memory
{
class PIMCtrl : public MemCtrl
{
  protected:
    Tick recvAtomic(PacketPtr pkt) override;
    void accessAndRespond(PacketPtr pkt, Tick static_latency,
                          MemInterface *mem_intr) override;

  public:
    PIMCtrl(const PIMCtrlParams &p);
};

} // namespace memory
} // namespace gem5

#endif // __PIM_CTRL_HH__
