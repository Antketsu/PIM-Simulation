/**
 * @file
 * PIMInterface declaration
 */

#ifndef __PIM_INTERFACE_HH__
#define __PIM_INTERFACE_HH__
#include <vector>
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

    typedef std::vector<uint16_t> SIMD_vector;

    class PIMInstruction
    {
      protected:
        PIMInstructionType type;

      public:
        PIMInstruction(PIMInstructionType _type);
        virtual void exec();
    };

    class ControlInstruction : public PIMInstruction
    {
      private:
        int8_t imm0, imm1;

      public:
        ControlInstruction(PIMInstructionType _type, int8_t _imm0,
                           int8_t _imm1);
        void exec() override;
    };

    class DataInstruction : public PIMInstruction
    {
      private:
        Operand dest, src0;
        int24_t dest_idx, src0_idx;
        bool do_relu;

      public:
        DataInstruction(PIMInstructionType _type, Operand _dest,
                        int24_t _dest_idx, Operand _src0, int24_t _src0_idx,
                        bool _do_relu);
        void exec() override;
    };

    class ALUInstruction : public PIMInstruction
    {
      private:
        Operand dest, src0, src1, src2;
        int24_t dest_idx, src0_idx, src1_idx;

      public:
        ALUInstruction(PIMInstructionType _type, Operand _dest,
                       int24_t _dest_idx, Operand _src0, int24_t _src0_idx,
                       Operand _src1, int24_t _src1_idx, Operand _src2);
        void exec() override;
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
    std::vector<PIMInstruction> crf;        // instruction register file
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

    SIMD_vector *getVector(Operand op_type, int24_t op_idx);

  public:
    PIMInterface(const PIMInterfaceParams &_p);
};

} // namespace memory
} // namespace gem5
