#include "mem/pim_interface.hh"

namespace gem5
{
namespace memory
{

PIMInterface::PIMInterface(const PIMInterfaceParams &_p)
    : DRAMInterface(_p),
      crf_entries(_p.crf_entries),
      grf_entries(_p.grf_entries),
      srf_entries(_p.srf_entries),
      simd_width(_p.simd_width),
      crf(std::vector<PIMInstruction *>(crf_entries, NULL)),
      grf_a(std::vector<std::vector<int16_t>>(
          _p.grf_entries / 2, std::vector<int16_t>(_p.simd_width))),
      grf_b(std::vector<std::vector<int16_t>>(
          _p.grf_entries / 2, std::vector<int16_t>(_p.simd_width))),
      srf_m(std::vector<std::vector<int16_t>>(
          _p.srf_entries / 2, std::vector<int16_t>(_p.simd_width))),
      srf_a(std::vector<std::vector<int16_t>>(
          _p.srf_entries / 2, std::vector<int16_t>(_p.simd_width))),
      pc(0),
      pim_mode(false),
      single_bank_mode(true),
      pim_range_start(_p.pim_range_start)
{
    DPRINTF(PIM,
            "Initialized PIMInterface with CRF entries %d, GRF entries %d, "
            "SRF entries %d, SIMD width %d, PIM range start %#x\n",
            crf_entries, grf_entries, srf_entries, simd_width,
            pim_range_start);
}

PIMInterface::~PIMInterface()
{
    for (auto &instr : crf) {
        delete instr;
    }
}

int16_t *
PIMInterface::getVector(Operand op_type, uint32_t op_idx, PacketPtr pkt)
{
    switch (op_type) {
        case NONE:
            return NULL;
        case GRF_A:
            return &(grf_a[op_idx][0]);
        case GRF_B:
            return &(grf_b[op_idx][0]);
        case SRF_M:
            return &(srf_m[op_idx][0]);
        case SRF_A:
            return &(srf_a[op_idx][0]);
        case BANK:
            return (int16_t *)toHostAddr(pkt->getAddr());
        default:
            panic("Unknown operand type %d for getVector\n", op_type);
    }
}
PIMInterface::PIMInstruction *
PIMInterface::format_instruction(uint32_t raw_instr)
{
    DPRINTF(PIM, "Formatting raw instruction 0x%x\n", raw_instr);
    // OPCode: [31:28]
    PIMInstructionType type =
        (PIMInstructionType)((raw_instr & ~0x0FFFFFFF) >> 28);
    if (type == NOP || type == JUMP || type == EXIT) { // Control
        // IMM0: [18:11] IMMU1: [10:0]
        int8_t imm0 = (raw_instr & ~0xFFF807FF) >> 11;
        int8_t imm1 = (raw_instr & ~0xFFFFF800);
        DPRINTF(PIM,
                "Formatted control instruction type %d "
                "imm0 %d imm1 %d\n",
                type, imm0, imm1);
        return new ControlInstruction(type, imm0, imm1);
    } else if (type == MOV) { // Data
        // DEST: [27:25] SRC0: [24:22] R: 12 DST_IDX: [10:8] SRC0_IDX: [6:4]
        Operand dest = (Operand)((raw_instr & ~0xF1FFFFFF) >> 25);
        Operand src0 = (Operand)((raw_instr & ~0xFE3FFFFF) >> 22);
        bool do_relu = (raw_instr & ~0xFFFFEFFF) >> 12;
        uint32_t dest_idx = (raw_instr & ~0xFFFFF8FF) >> 8;
        uint32_t src0_idx = (raw_instr & ~0xFFFFFF8F) >> 4;
        DPRINTF(PIM,
                "Formatted data instruction type %d "
                "dest %d dest_idx %d src0 %d src0_idx %d do_relu %d\n",
                type, dest, dest_idx, src0, src0_idx, do_relu);
        return new DataInstruction(type, dest, dest_idx, src0, src0_idx,
                                   do_relu);
    } else if (type == ADD || type == MUL || type == MAD ||
               type == MAC) { // ALU
        // DEST: [27:25] SRC0: [24:22] SRC1: [21:19]
        // DST_IDX: [10:8] SRC0_IDX: [6:4] SRC1_IDX: [2:0]
        Operand dest = (Operand)((raw_instr & ~0xF1FFFFFF) >> 25);
        Operand src0 = (Operand)((raw_instr & ~0xFE3FFFFF) >> 22);
        Operand src1 = (Operand)((raw_instr & ~0xFFC7FFFF) >> 19);
        Operand src2 = (Operand)((raw_instr & ~0xFFF8FFFF) >> 16);
        uint32_t dest_idx = (raw_instr & ~0xFFFFF8FF) >> 8;
        uint32_t src0_idx = (raw_instr & ~0xFFFFFF8F) >> 4;
        uint32_t src1_idx = (raw_instr & ~0xFFFFFFF8);
        DPRINTF(PIM,
                "Formatted ALU instruction type %d "
                "dest %d dest_idx %d src0 %d src0_idx %d "
                "src1 %d src1_idx %d src2 %d src2_idx %d\n",
                type, dest, dest_idx, src0, src0_idx, src1, src1_idx, src2,
                src1_idx);
        return new ALUInstruction(type, dest, dest_idx, src0, src0_idx, src1,
                                  src1_idx, src2);
    } else {
        panic("Unknown instruction type %d\n", type);
    }
}

void
PIMInterface::incrementPC()
{
    ++pc;
}

void
PIMInterface::decrementPC(uint8_t stride)
{
    pc -= stride;
}

void
PIMInterface::deactivatePIMMode()
{
    pim_mode = false;
    DPRINTF(PIM, "Exiting PIM mode\n");
}

uint8_t
PIMInterface::getSIMDWidth()
{
    return simd_width;
}

void
PIMInterface::access(PacketPtr pkt)
{
    bool response_done = false;
    DPRINTF(PIM, "PIMInterface::access called with addr 0x%x, pim_mode=%d\n",
            pkt->getAddr(), pim_mode);
    if (pim_mode) {
        DPRINTF(PIM, "PIM mode active, executing kernel\n");
        executeKernel(pkt);
    } else {
        Addr addr = pkt->getAddr();
        // skip pim and single bank registers, 32 bits per CRF entry,
        AddrRange crf_range =
            AddrRange(pim_range_start + 2, pim_range_start + crf_entries * 4);
        AddrRange srf_range =
            AddrRange(crf_range.end(),
                      crf_range.end() + (srf_m.size() + srf_a.size()) *
                                            2); // 16 bits per scalar register
        AddrRange grf_range =
            AddrRange(srf_range.end(),
                      srf_range.end() + (grf_a.size() + grf_b.size()) *
                                            simd_width * 2); // 16 bits
                                                             // per vector
                                                             // element
        if (addr == pim_range_start) {
            // Access PIM mode register
            pim_mode = true;
            DPRINTF(PIM, "Entering PIM mode\n");
        } else if (addr == pim_range_start + 1) {
            // Access single bank mode register
            single_bank_mode = !single_bank_mode;
            DPRINTF(PIM, "Setting single bank mode to %d\n", single_bank_mode);
        } else if (crf_range.contains(addr)) {
            // Access CRF
            int idx = (addr - crf_range.start()) / 4;
            uint32_t raw_instr = *(pkt->getConstPtr<uint32_t>());
            crf[idx] = format_instruction(raw_instr);
            DPRINTF(PIM, "Loaded instruction %s into CRF index %d\n",
                    crf[idx]->getType(), idx);
        } else if (srf_range.contains(addr)) {
            // Access SRF
            int idx = (addr - srf_range.start()) / 2;
            uint16_t val = *(pkt->getConstPtr<uint16_t>());
            if (idx < srf_m.size()) {
                for (int i = 0; i < simd_width; ++i) {
                    srf_m[idx][i] = val;
                }
            } else {
                for (int i = 0; i < simd_width; ++i) {
                    srf_a[idx - srf_m.size()][i] = val;
                }
            }
            DPRINTF(PIM, "Loaded value %d into SRF index %d\n",
                    (idx < srf_m.size()) ? srf_m[idx][0]
                                         : srf_a[idx - srf_m.size()][0],
                    idx);
        } else if (grf_range.contains(addr)) {
            // TO-DO: Access GRF
            DPRINTF(PIM, "Access to GRF at address %#x not implemented yet\n",
                    addr);
        } else {
            // Address is not in PIM range, access normal DRAM
            DPRINTF(PIM, "Normal DRAM access at address %#x\n", addr);
            DRAMInterface::access(pkt);
            response_done = true;
        }
    }
    if (pkt->needsResponse() && !response_done) {
        pkt->makeResponse();
    }
}

void
PIMInterface::executeKernel(PacketPtr pkt)
{
    if (pc >= crf.size()) {
        panic("Program counter %d exceeds instruction register file size %d\n",
              pc, crf.size());
    }
    if (pim_mode) {
        DPRINTF(PIM, "Executing instruction %d\n", pc);
        crf[pc]->exec(pkt, this);
    }
}

PIMInterface::PIMInstruction::PIMInstruction(PIMInstructionType _type)
    : type(_type)
{}

std::string
PIMInterface::PIMInstruction::getType()
{
    switch (type) {
        case NOP:
            return "NOP";
        case JUMP:
            return "JUMP";
        case EXIT:
            return "EXIT";
        case MOV:
            return "MOV";
        case ADD:
            return "ADD";
        case MUL:
            return "MUL";
        case MAC:
            return "MAC";
        case MAD:
            return "MAD";
        default:
            return "UNKNOWN";
    }
}

PIMInterface::ControlInstruction::ControlInstruction(PIMInstructionType _type,
                                                     int8_t _imm0,
                                                     int8_t _imm1)
    : PIMInstruction(_type), imm0(_imm0), imm1(_imm1)
{}

void
PIMInterface::ControlInstruction::exec(PacketPtr pkt, PIMInterface *pim)
{
    switch (type) {
        case NOP:
            pim->incrementPC();
            break;
        case JUMP:
            if (imm1 > 0) {
                pim->decrementPC(imm0);
                --imm1;
            } else {
                pim->incrementPC();
            }
            break;
        case EXIT:
            pim->deactivatePIMMode();
            break;
        default:
            panic("Unknown control instruction type %d\n", type);
    }
}

PIMInterface::DataInstruction::DataInstruction(
    PIMInstructionType _type, Operand _dest, uint32_t _dest_idx, Operand _src0,
    uint32_t _src0_idx, bool _do_relu)
    : PIMInstruction(_type),
      dest(_dest),
      src0(_src0),
      dest_idx(_dest_idx),
      src0_idx(_src0_idx),
      do_relu(_do_relu)
{}

void
PIMInterface::DataInstruction::exec(PacketPtr pkt, PIMInterface *pim)
{
    int16_t *src0_vector = pim->getVector(src0, src0_idx, pkt);
    int16_t *dest_vector = pim->getVector(dest, dest_idx, pkt);
    switch (type) {
        case MOV:
            for (int i = 0; i < pim->getSIMDWidth(); ++i) {
                dest_vector[i] = src0_vector[i];
                if (do_relu && dest_vector[i] < 0) {
                    dest_vector[i] = 0;
                }
            }
            break;
        default:
            panic("Unknown data instruction type %d\n", type);
    }
    pim->incrementPC();
}

PIMInterface::ALUInstruction::ALUInstruction(PIMInstructionType _type,
                                             Operand _dest, uint32_t _dest_idx,
                                             Operand _src0, uint32_t _src0_idx,
                                             Operand _src1, uint32_t _src1_idx,
                                             Operand _src2)
    : PIMInstruction(_type),
      dest(_dest),
      src0(_src0),
      src1(_src1),
      src2(_src2),
      dest_idx(_dest_idx),
      src0_idx(_src0_idx),
      src1_idx(_src1_idx)
{}

void
PIMInterface::ALUInstruction::exec(PacketPtr pkt, PIMInterface *pim)
{
    int16_t *op0_vector = pim->getVector(src0, src0_idx, pkt);
    int16_t *op1_vector = pim->getVector(src1, src1_idx, pkt);
    int16_t *dest_vector = pim->getVector(dest, dest_idx, pkt);
    int16_t *op2_vector =
        pim->getVector(src2, src1_idx, pkt); // src2 uses src1_idx
    switch (type) {
        case ADD:
            assert(dest == GRF_A || dest == GRF_B);
            for (int i = 0; i < pim->getSIMDWidth(); ++i) {
                dest_vector[i] = op0_vector[i] + op1_vector[i];
            }
            break;
        case MUL:
            assert(dest == GRF_A || dest == GRF_B);
            assert(src0 != SRF_M);
            for (int i = 0; i < pim->getSIMDWidth(); ++i) {
                dest_vector[i] = op0_vector[i] * op1_vector[i];
            }
            break;
        case MAC:
            assert(dest == GRF_B);
            for (int i = 0; i < pim->getSIMDWidth(); ++i) {
                dest_vector[i] += op0_vector[i] * op1_vector[i];
            }
            break;
        case MAD:
            assert(dest == GRF_A || dest == GRF_B);
            for (int i = 0; i < pim->getSIMDWidth(); ++i) {
                dest_vector[i] = op0_vector[i] * op1_vector[i] + op2_vector[i];
            }
            break;
        default:
            panic("Unknown ALU instruction type %d\n", type);
    }
    pim->incrementPC();
}

} // namespace memory
} // namespace gem5
