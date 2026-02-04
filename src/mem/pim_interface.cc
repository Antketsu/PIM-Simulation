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
      single_bank_mode(true),
      pim_range_start(_p.pim_range_start())
{}

uint16_t *
PIMInterface::getVector(Operand op_type, int24_t op_idx, PacketPtr pkt)
{
    switch (op_type) {
        case GRF_A:
            return &(grf_a[op_idx][0]);
        case GRF_B:
            return &(grf_b[op_idx][0]);
        case SRF_M:
            return &(srf_m[op_idx][0]);
        case SRF_A:
            return &(srf_a[op_idx][0]);
        case BANK:
            return (uint16_t *)toHostAddr(pkt->getAddr());
        default:
            panic("Unknown operand type %d for getVector\n", op_type);
    }
}
PIMInterface::PIMInstruction
PIMInterface::format_instruction(uint32_t raw_instr)
{
    // OPCode: [31:28]
    PIMInstructionType type = (raw_instr & ~0x0FFFFFFF) >> 28;
    if (type == NOP || type == JUMP || type == EXIT) { // Control
        // IMM0: [18:11] IMMU1: [10:0]
        int8_t imm0 = (raw_instr & ~0xFFF807FF) >> 11;
        int8_t imm1 = (raw_instr & ~0xFFFFF800);
        return ControlInstruction(type, imm0, imm1);
    } else if (type == MOV) { // Data
        // DEST: [27:25] SRC0: [24:22] R: 12 DST_IDX: [10:8] SRC0_IDX: [6:4]
        Operand dest = (raw_instr & ~0xF1FFFFFF) >> 25;
        Operand src0 = (raw_instr & ~0xFE3FFFFFF) >> 22;
        bool do_relu = (raw_instr & ~0xFFFFEFFF) >> 12;
        int24_t dest_idx = (raw_instr & ~0xFFFFF8FF) >> 8;
        int24_t src0_idx = (raw_instr & ~0xFFFFFF8F) >> 4;
        return DataInstruction(type, dest, dest_idx, src0, src0_idx, do_relu);
    } else if (type == ADD || type == MUL || type == MAD ||
               type == MAC) { // ALU
        // DEST: [27:25] SRC0: [24:22] SRC1: [21:19]
        // DST_IDX: [10:8] SRC0_IDX: [6:4] SRC1_IDX: [2:0]
        Operand dest = (raw_instr & ~0xF1FFFFFF) >> 25;
        Operand src0 = (raw_instr & ~0xFE3FFFFFF) >> 22;
        Operand src1 = (raw_instr & ~0xFFC7FFFF) >> 19;
        Operand src2 = (raw_instr & ~0xFFF8FFFF) >> 16;
        int24_t dest_idx = (raw_instr & ~0xFFFFF8FF) >> 8;
        int24_t src0_idx = (raw_instr & ~0xFFFFFF8F) >> 4;
        int24_t src1_idx = (raw_instr & ~0xFFFFFFF8);
        return ALUInstruction(type, dest, dest_idx, src0, src0_idx, src1,
                              src1_idx, src2, src1_idx);
    } else {
        panic("Unknown instruction type %d\n", type);
    }
}

void
PIMInterface::access(PacketPtr pkt)
{
    if (pim_mode) {
        executeKernel(pkt);
    } else {
        Addr addr = pkt->getAddr();
        // skip pim and single bank registers, 32 bits per CRF entry,
        crf_range =
            AddrRange(pim_range_start + 2, pim_range_start + crf.size() * 4);
        srf_range =
            AddrRange(crf_range.end(),
                      crf_range.end() + (srf_m.size() + srf_a.size()) *
                                            2); // 16 bits per scalar register
        grf_range =
            AddrRange(srf_range.end(),
                      srf_range.end() + (grf_a.size() + grf_b.size()) *
                                            simd_width * 2); // 16 bits
                                                             // per vector
                                                             // element
        if (addr == pim_range_start) {
            // Access PIM mode register
            pim_mode = true;
        } else if (addr == pim_range_start + 1) {
            // Access single bank mode register
            single_bank_mode = !single_bank_mode;
        } else if (crf_range.contains(addr)) {
            // Access CRF
            int idx = (addr - crf_range.start) / 4;
            crf[idx] = PIMInstructionType(pkt->getUint32());
        } else if (srf_range.contains(addr)) {
            // Access SRF
            int idx = (addr - srf_range.start) / 2;
            if (idx < srf_m.size()) {
                srf_m[idx] = pkt->getUint16();
            } else {
                srf_a[idx - srf_m.size()] = pkt->getUint16();
            }
        } else if (grf_range.contains(addr)) {
            // TO-DO: Access GRF
        } else {
            // Address is not in PIM range, access normal DRAM
            DRAMInterface::access(pkt);
        }
    }
}
void
PIMInterface::executeKernel(PacketPtr pkt)
{
    if (pc >= crf.size()) {
        panic("Program counter %d exceeds instruction register file size %d\n",
              pc, crf.size());
    }
    while (pim_mode) {
        PIMInstruction &instr = crf[pc];
        instr.exec(pkt);
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

PIMInterface::ControlInstruction::exec(PacketPtr pkt)
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

PIMInterface::DataInstruction::exec(PacketPtr pkt)
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

PIMInterface::ALUInstruction::exec(PacketPtr pkt)
{
    uint16_t *op0_vector = getVector(src0, src0_idx);
    uint16_t *op1_vector = getVector(src1, src1_idx);
    uint16_t *dest_vector = getVector(dest, dest_idx);
    switch (type) {
        case ADD:
            assert(dest == GRF_A || dest == GRF_B);
            for (int i = 0; i < simd_width; ++i) {
                dest_vector[i] = op0_vector[i] + op1_vector[i];
            }
            break;
        case MUL:
            assert(dest == GRF_A || dest == GRF_B);
            assert(src0 != SRF_M);
            for (int i = 0; i < simd_width; ++i) {
                dest_vector[i] = op0_vector[i] * op1_vector[i];
            }
            break;
        case MAC:
            assert(dest == GRF_B);
            for (int i = 0; i < simd_width; ++i) {
                dest_vector[i] += op0_vector[i] * op1_vector[i];
            }
            break;
        case MAD:
            assert(dest == GRF_A || dest == GRF_B);
            SIMD_vector *op2_vector =
                getVector(src2, src1_idx, pkt); // src2 uses src1_idx
            for (int i = 0; i < simd_width; ++i) {
                dest_vector[i] =
                    op0_vector[i] * op1_vector[i] + op2_vector->at(i);
            }
            break;
        default:
            panic("Unknown ALU instruction type %d\n", type);
    }
    ++pc;
}

} // namespace memory
} // namespace gem5
