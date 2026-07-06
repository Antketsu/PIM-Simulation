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
    PIMInterface *pim_intr;
    std::deque<MemPacket *> pim_queue;
    Tick lastFetch = -1;
    Tick pipelineEnd = -1;
    struct PIMCtrlStats : public statistics::Group
    {
        PIMCtrlStats(PIMCtrl &_pim);

        PIMCtrl &pim_ctrl;

        statistics::Scalar PIMReads;
        statistics::Scalar PIMWrites;

    } pim_stats;
    Tick recvAtomic(PacketPtr pkt) override;
    void accessAndRespond(PacketPtr pkt, Tick static_latency,
                          MemInterface *mem_intr) override;
    //bool recvTimingReq(PacketPtr pkt) override;
    /*void processNextReqEvent(MemInterface* mem_intr,
                        MemPacketQueue& resp_queue,
                        EventFunctionWrapper& resp_event,
                        EventFunctionWrapper& next_req_event,
                        bool& retry_wr_req) override;
    */
    void addToPIMQueue(PacketPtr pkt);
    //Tick issuePIM(MemPacket* mem_pkt, MemInterface* mem_intr);

  public:
    PIMCtrl(const PIMCtrlParams &p);
};

} // namespace memory
} // namespace gem5

#endif // __PIM_CTRL_HH__
