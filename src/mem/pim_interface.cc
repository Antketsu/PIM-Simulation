#include "mem/pim_interface.hh"

namespace gem5
{
namespace memory
{

PIMInterface::PIMInterface(const PIMInterfaceParams &_p)
    : DRAMInterface(_p),
      crf(std::vector<PIMInstruction>(_p.crf_entries)),
      grf_a(std::vector<std::vector<uint16_t>>(
          _p.grf_entries / 2, std::vector<uint16_t>(_p.simd_width))),
      grf_b(std::vector<std::vector<uint16_t>>(
          _p.grf_entries / 2, std::vector<uint16_t>(_p.simd_width))),
      srf_m(std::vector<uint16_t>(_p.srf_entries / 2)),
      srf_a(std::vector<uint16_t>(_p.srf_entries / 2)),
      simd_width(_p.simd_width),
      pc(0),
      pim_mode(false),
      single_bank_mode(true)
{}

PIMInterface::SIMD_vector *
PIMInterface::getVector(Operand op_type, int24_t op_idx)
{
    switch (op_type) {
        case GRF_A:
            return &grf_a[op_idx];
        case GRF_B:
            return &grf_b[op_idx];
        case SRF_M:
            return &srf_m[op_idx];
        case SRF_A:
            return &srf_a[op_idx];
        case BANK:
            // TODO: implement BANK operand fetch
            break;
        default:
            panic("Unknown operand type %d for getVector\n", op_type);
    }
}

PIMInterface::PIMInstruction::PIMInstruction(PIMInstructionType _type)
    : type(_type)
{}

PIMInterface::ControlInstruction::ControlInstruction(PIMInstructionType _type,
                                                     int8_t _imm0,
                                                     int8_t _imm1)
    : PIMInstruction(_type), imm0(_imm0), imm1(_imm1)
{}

PIMInterface::ControlInstruction::exec()
{
    switch (type) {
        case NOP:
            ++pc;
            break;
        case JUMP:
            if (imm1 > 0) {
                pc -= imm0;
            }
            break;
        case EXIT:
            pim_mode = false;
            break;
        default:
            panic("Unknown control instruction type %d\n", type);
    }
}

PIMInterface::DataInstruction::DataInstruction(
    PIMInstructionType _type, Operand _dest, int24_t _dest_idx, Operand _src0,
    int24_t _src0_idx, bool _do_relu)
    : PIMInstruction(_type),
      dest(_dest),
      dest_idx(_dest_idx),
      src0(_src0),
      src0_idx(_src0_idx),
      do_relu(_do_relu)
{}

PIMInterface::DataInstruction::exec()
{
    switch (type) {
        case MOV:
            assert(dest == GRF_A || dest == GRF_B);
            SIMD_vector *src0_vector = getVector(src0, src0_idx);
            SIMD_vector *dest_vector = getVector(dest, dest_idx);
            for (int i = 0; i < simd_width; ++i) {
                dest_vector->at(i) = src0_vector->at(i);
                if (do_relu && dest_vector->at(i) < 0) {
                    dest_vector->at(i) = 0;
                }
            }
            break;
        default:
            panic("Unknown data instruction type %d\n", type);
            ++pc;
    }
}

PIMInterface::ALUInstruction::ALUInstruction(PIMInstructionType _type,
                                             Operand _dest, int24_t _dest_idx,
                                             Operand _src0, int24_t _src0_idx,
                                             Operand _src1, int24_t _src1_idx)
    : PIMInstruction(_type),
      dest(_dest),
      dest_idx(_dest_idx),
      src0(_src0),
      src0_idx(_src0_idx),
      src1(_src1),
      src1_idx(_src1_idx),
{}

PIMInterface::ALUInstruction::exec()
{
    SIMD_vector *op0_vector = getVector(src0, src0_idx);
    SIMD_vector *op1_vector = getVector(src1, src1_idx);
    SIMD_vector *dest_vector = getVector(dest, dest_idx);
    switch (type) {
        case ADD:
            assert(dest == GRF_A || dest == GRF_B);
            for (int i = 0; i < simd_width; ++i) {
                dest_vector->at(i) = op0_vector->at(i) + op1_vector->at(i);
            }
            break;
        case MUL:
            assert(dest == GRF_A || dest == GRF_B);
            assert(src0 != SRF_M);
            for (int i = 0; i < simd_width; ++i) {
                dest_vector->at(i) = op0_vector->at(i) * op1_vector->at(i);
            }
            break;
        case MAC:
            assert(dest == GRF_B);
            for (int i = 0; i < simd_width; ++i) {
                dest_vector->at(i) += op0_vector->at(i) * op1_vector->at(i);
            }
            break;
        case MAD:
            assert(dest == GRF_A || dest == GRF_B);
            SIMD_vector *op2_vector =
                getVector(src2, src1_idx); // src2 uses src1_idx
            for (int i = 0; i < simd_width; ++i) {
                dest_vector->at(i) =
                    op0_vector->at(i) * op1_vector->at(i) + op2_vector->at(i);
            }
            break;
        default:
            panic("Unknown ALU instruction type %d\n", type);
    }
    ++pc;
}

} // namespace memory
} // namespace gem5
