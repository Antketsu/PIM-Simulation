/**
 * @file
 * PIMInterface declaration
 */

#ifndef __PIM_INTERFACE_HH__
#define __PIM_INTERFACE_HH__
#include <memory>
#include <vector>
#include "debug/DRAMPower.hh"
#include "debug/PIM.hh"
#include "mem/dram_interface.hh"
#include "mem/drampower.hh"
#include "params/PIMInterface.hh"

namespace gem5
{
namespace memory
{

class PIMInterface : public DRAMInterface
{
  protected:
    struct PIMStats : public statistics::Group
    {
        PIMStats(PIMInterface &_pim);

        PIMInterface &pim_intr;
        statistics::Scalar ctrl_instrs_executed;
        statistics::Scalar data_instrs_executed;
        statistics::Scalar alu_instrs_executed;
        statistics::Scalar grf_reads;
        statistics::Scalar grf_writes;
        statistics::Scalar crf_reads;
        statistics::Scalar crf_writes;
        statistics::Scalar srf_reads;
        statistics::Scalar srf_writes;
        statistics::Scalar pim_mode_switches;
        statistics::Scalar all_bank_mode_switches;
        statistics::Scalar total_ticks_between_instrs;
        statistics::Scalar total_gaps_between_instrs;
        statistics::Formula avg_ticks_between_instrs;
    } pim_stats;
    enum PIMInstructionType
    {
        NOP = 0,
        JUMP,
        EXIT,
        MOV,
        ADD,
        MUL,
        MAD,
        MAC
    };

    enum Operand
    {
        NONE = 0,
        GRF_A,
        GRF_B,
        ODD_BANK,
        EVEN_BANK,
        SRF_M,
        SRF_A
    };

    typedef std::vector<int16_t> SIMD_vector;

    class PIMInstruction
    {
      protected:
        PIMInstructionType type;

      public:
        PIMInstruction(PIMInstructionType _type = NOP);
        std::string getType();
        virtual void
        exec(Addr addr, PIMInterface *pim, uint8_t pu, bool is_write)
        { panic("exec() not implemented for base PIMInstruction class\n"); }
        virtual void
        rst()
        {}
    };

    class ControlInstruction : public PIMInstruction
    {
      private:
        uint8_t imm0, imm1, cnt;

      public:
        ControlInstruction(PIMInstructionType _type, int8_t _imm0,
                           int8_t _imm1);
        void exec(Addr addr, PIMInterface *pim, uint8_t pu,
                  bool is_write) override;
        void rst() override;
    };

    class DataInstruction : public PIMInstruction
    {
      private:
        Operand dest, src0;
        uint32_t dest_idx, src0_idx;
        bool do_relu;

      public:
        DataInstruction(PIMInstructionType _type, Operand _dest,
                        uint32_t _dest_idx, Operand _src0, uint32_t _src0_idx,
                        bool _do_relu);
        void exec(Addr addr, PIMInterface *pim, uint8_t pu,
                  bool is_write) override;
    };

    class ALUInstruction : public PIMInstruction
    {
      private:
        Operand dest, src0, src1, src2;
        uint32_t dest_idx, src0_idx, src1_idx;

      public:
        ALUInstruction(PIMInstructionType _type, Operand _dest,
                       uint32_t _dest_idx, Operand _src0, uint32_t _src0_idx,
                       Operand _src1, uint32_t _src1_idx, Operand _src2);
        void exec(Addr addr, PIMInterface *pim, uint8_t pu,
                  bool is_write) override;
    };

    /*
     * Scalar constants
     */
    const uint8_t crf_entries;
    const uint8_t grf_entries;
    const uint8_t srf_entries;
    const uint8_t simd_width;
    /*
     * Accelerator registers
     */

    struct PIMProcessingUnit
    {
        PIMProcessingUnit(uint8_t srf_entries, uint8_t grf_entries,
                          uint8_t simd_width);
        std::vector<SIMD_vector>
            srf_m; // scalar add register file, it replicates
                   // a constant value in a vector
        std::vector<SIMD_vector>
            srf_a; // scalar mul register file, it replicates
                   // a constant value in a vector
        std::vector<SIMD_vector> grf_a; // vector register file
        std::vector<SIMD_vector> grf_b; // vector register file
    };
    std::vector<PIMInstruction *> crf; // instruction register file
    std::vector<PIMProcessingUnit> processing_units; // processing units
    /*
     * Program counter
     */
    uint8_t pc = 0;
    /*
     * State variables
     */
    bool pim_mode;      // PIM mode enabled/disabled
    bool all_bank_mode; // all bank mode enabled/disabled

    bool pending_to_precharge; // whether we are waiting to precharge after
                               // mode switch
    Tick last_fetch; // last instruction fetch time

    /*
     * Start address of the PIM memory region
     */
    Addr pim_range_start;
    uint8_t decodeBank(Addr pkt_addr);
    int16_t *getVector(uint8_t pu, Operand op_type, uint32_t op_idx, Addr addr,
                       bool is_write);
    PIMInstruction *format_instruction(uint32_t raw_instr);
    Addr modifyAddrForBank(Addr original_addr, uint8_t target_bank);
    void executeKernel(PacketPtr pkt);

  public:
    PIMInterface(const PIMInterfaceParams &_p);
    void access(PacketPtr pkt);
    //std::pair<Tick, Tick>
    //issuePIM(MemPacket *mem_pkt, Tick next_burst_at);
    std::pair<Tick, Tick> beginEndNextInstr(MemPacket *mem_pkt, Tick last_fetch);
    std::pair<Tick, Tick> doBurstAccess(MemPacket *mem_pkt, Tick next_burst_at,
                                      const std::vector<MemPacketQueue>& queue) override;
    void incrementPC();
    void decrementPC(uint8_t stride);
    void deactivatePIMMode();
    bool inPIMMode();
    uint8_t getSIMDWidth();
    ~PIMInterface();
};

} // namespace memory
} // namespace gem5

#endif // __PIM_INTERFACE_HH__
