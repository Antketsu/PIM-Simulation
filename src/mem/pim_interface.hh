/**
 * @file
 * PIMInterface declaration
 */

#ifndef __PIM_INTERFACE_HH__
#define __PIM_INTERFACE_HH__
#include <memory>
#include <vector>
#include "debug/PIM.hh"
#include "mem/dram_interface.hh"
#include "params/PIMInterface.hh"

namespace gem5
{
namespace memory
{

class PIMInterface : public DRAMInterface
{
  private:
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
        BANK,
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
        exec(PacketPtr pkt, PIMInterface *pim)
        {
            panic("exec() not implemented for base PIMInstruction class\n");
        }
    };

    class ControlInstruction : public PIMInstruction
    {
      private:
        int8_t imm0, imm1;

      public:
        ControlInstruction(PIMInstructionType _type, int8_t _imm0,
                           int8_t _imm1);
        void exec(PacketPtr pkt, PIMInterface *pim) override;
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
        void exec(PacketPtr pkt, PIMInterface *pim) override;
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
        void exec(PacketPtr pkt, PIMInterface *pim) override;
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
    std::vector<PIMInstruction *> crf;      // instruction register file
    std::vector<SIMD_vector> grf_a;         // vector register file
    std::vector<SIMD_vector> grf_b;         // vector register file
    std::vector<SIMD_vector> srf_m; // scalar add register file, it replicates
                                    // a constant value in a vector
    std::vector<SIMD_vector> srf_a; // scalar mul register file, it replicates
                                    // a constant value in a vector
    /*
     * Program counter
     */
    uint8_t pc = 0;
    /*
     * State variables
     */
    bool pim_mode;         // PIM mode enabled/disabled
    bool single_bank_mode; // single bank mode enabled/disabled

    /*
     * Start address of the PIM memory region
     */
    Addr pim_range_start;

    int16_t *getVector(Operand op_type, uint32_t op_idx, PacketPtr pkt);
    PIMInstruction *format_instruction(uint32_t raw_instr);
    void executeKernel(PacketPtr pkt);

  public:
    PIMInterface(const PIMInterfaceParams &_p);
    void access(PacketPtr pkt);
    /*std::pair<Tick, Tick>
    doBurstAccess(MemPacket* mem_pkt, Tick next_burst_at,
                  const std::vector<MemPacketQueue>& queue)
                  override;*/
    void incrementPC();
    void decrementPC(uint8_t stride);
    void deactivatePIMMode();
    uint8_t getSIMDWidth();
    ~PIMInterface();
};

} // namespace memory
} // namespace gem5

#endif // __PIM_INTERFACE_HH__
