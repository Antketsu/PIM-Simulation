#include "mem/pim_interface.hh"
#include "base/types.hh"
#include "debug/DRAM.hh"
#include "debug/PIM_PIPELINE.hh"
#include "mem/mem_ctrl.hh"
#include "sim/cur_tick.hh"
namespace gem5
{

using namespace Data;

namespace memory
{

PIMInterface::PIMProcessingUnit::PIMProcessingUnit(uint8_t srf_entries,
                                                   uint8_t grf_entries,
                                                   uint8_t simd_width)
    : srf_m(std::vector<std::vector<int16_t>>(
          srf_entries / 2, std::vector<int16_t>(simd_width))),
      srf_a(std::vector<std::vector<int16_t>>(
          srf_entries / 2, std::vector<int16_t>(simd_width))),
      grf_a(std::vector<std::vector<int16_t>>(
          grf_entries / 2, std::vector<int16_t>(simd_width))),
      grf_b(std::vector<std::vector<int16_t>>(
          grf_entries / 2, std::vector<int16_t>(simd_width)))
{}

PIMInterface::PIMInterface(const PIMInterfaceParams &_p)
: DRAMInterface(_p),
      pim_stats(*this),
      crf_entries(_p.crf_entries),
      grf_entries(_p.grf_entries),
      srf_entries(_p.srf_entries),
      simd_width(_p.simd_width),
      crf(std::vector<PIMInstruction *>(crf_entries, NULL)),
      processing_units(std::vector<PIMProcessingUnit>(
          _p.banks_per_rank / 2,
          PIMProcessingUnit(srf_entries, grf_entries, simd_width))),
      pc(0),
      pim_mode(false),
      all_bank_mode(false),
      pim_range_start(_p.pim_range_start)
{   
    size_t srf_size = srf_entries * 2; // 16 bits per scalar register
    size_t grf_size =
        grf_entries * simd_width * 2; // 16 bits per vector register entry
    crf_range = AddrRange(pim_range_start + 8, pim_range_start + 8 + crf_entries * 4);
    pu_range = AddrRange(
          crf_range.end(),
          crf_range.end() + processing_units.size() * (srf_size + grf_size));
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

PIMInterface::PIMStats::PIMStats(PIMInterface &_pim)
    : Group(&_pim),
      pim_intr(_pim),
      ctrl_instrs_executed(this, "ctrl_instrs_executed",
                           "Number of control instructions executed"),
      data_instrs_executed(this, "data_instrs_executed",
                           "Number of data instructions executed"),
      alu_instrs_executed(this, "alu_instrs_executed",
                          "Number of ALU instructions executed"),
      grf_reads(this, "grf_reads", "Number of GRF read operations"),
      grf_writes(this, "grf_writes", "Number of GRF write operations"),
      crf_reads(this, "crf_reads", "Number of CRF read operations"),
      crf_writes(this, "crf_writes", "Number of CRF write operations"),
      srf_reads(this, "srf_reads", "Number of SRF read operations"),
      srf_writes(this, "srf_writes", "Number of SRF write operations"),
      pim_mode_switches(this, "pim_mode_switches",
                        "Number of PIM mode switches"),
      all_bank_mode_switches(this, "all_bank_mode_switches",
                             "Number of all bank mode switches"),
      total_ticks_between_instrs(this, "total_ticks_between_instrs",
                                 "Total ticks between instructions"),
      total_gaps_between_instrs(this, "total_gaps_between_instrs",
                                 "Total gaps between instructions"),
      avg_ticks_between_instrs(this, "avg_ticks_between_instrs",
                                "Average ticks between instructions"),
      pim_conf_accesses(this, "pim_conf_accesses", "Number of PIM configuration accesses"),
      hist_ticks_between_instrs(this, "hist_ticks_between_instrs", "Histogram of ticks between instructions")

{
    avg_ticks_between_instrs = total_ticks_between_instrs / total_gaps_between_instrs;
    hist_ticks_between_instrs.init(100); // Initialize histogram with 100 buckets
}

uint8_t
PIMInterface::decodeBank(Addr pkt_addr)
{
    Addr addr = getCtrlAddr(pkt_addr);

    addr = addr / burstSize;

    if (addrMapping == enums::RoRaBaChCo || addrMapping == enums::RoRaBaCoCh) {
        addr = addr / burstsPerRowBuffer;
        return addr % banksPerRank;
    } else if (addrMapping == enums::RoCoRaBaCh) {
        if (burstsPerStripe > burstsPerRowBuffer) {
            addr = addr / burstsPerRowBuffer;
        } else {
            addr = addr / burstsPerStripe;
        }
        return addr % banksPerRank;
    }

    panic("Mapping not supported for decodeBank in PIMInterface\n");
}

Addr
PIMInterface::modifyAddrForBank(Addr original_addr, uint8_t target_bank)
{
    Addr column_bits_size = burstSize * burstsPerRowBuffer;

    Addr high_part = (original_addr / (column_bits_size * banksPerRank)) *
                     (column_bits_size * banksPerRank);
    Addr low_part = original_addr % column_bits_size;

    Addr bank_part = (Addr)target_bank * column_bits_size;

    return high_part + bank_part + low_part;
}

int16_t *
PIMInterface::getVector(uint8_t pu, Operand op_type, uint32_t op_idx,
                        Addr addr, bool is_write)
{
    PIMInterface::PIMProcessingUnit &pu_ref = processing_units[pu];
    uint8_t bank = decodeBank(addr);
    DPRINTF(PIM, "Bank %d decoded for address %#x\n", bank, addr);
    switch (op_type) {
        case NONE:
            return NULL;
        case GRF_A:
            if (is_write) {
                pim_stats.grf_writes++;
            } else {
                pim_stats.grf_reads++;
            }
            return &(pu_ref.grf_a[op_idx][0]);
        case GRF_B:
            if (is_write) {
                pim_stats.grf_writes++;
            } else {
                pim_stats.grf_reads++;
            }
            return &(pu_ref.grf_b[op_idx][0]);
        case SRF_M:
            if (is_write) {
                pim_stats.srf_writes++;
            } else {
                pim_stats.srf_reads++;
            }
            return &(pu_ref.srf_m[op_idx][0]);
        case SRF_A:
            if (is_write) {
                pim_stats.srf_writes++;
            } else {
                pim_stats.srf_reads++;
            }
            return &(pu_ref.srf_a[op_idx][0]);
        case ODD_BANK:
            // DPRINTF(PIM, "Decoding address %#x to bank %d for PU %d\n",
            // addr,
            //         bank, pu);
            assert(bank == 2 * pu);
            return (int16_t *)toHostAddr(addr);
        case EVEN_BANK:
            // DPRINTF(PIM, "Decoding address %#x to bank %d for PU %d\n",
            // addr,
            //         bank, pu);
            assert(bank == 2 * pu + 1);
            return (int16_t *)toHostAddr(addr);
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
        uint8_t imm0 = (raw_instr & ~0xFFF807FF) >> 11;
        uint8_t imm1 = (raw_instr & ~0xFFFFF800);
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
{ ++pc; }

void
PIMInterface::decrementPC(uint8_t stride)
{ pc -= stride; }

void
PIMInterface::deactivatePIMMode()
{
    pim_mode = false;
    DPRINTF(PIM, "Exiting PIM mode\n");
}

bool
PIMInterface::inPIMMode()
{ return pim_mode; }

uint8_t
PIMInterface::getSIMDWidth()
{ return simd_width; }

std::pair<Tick, Tick>
PIMInterface::beginEndNextInstr(MemPacket *mem_pkt, Tick last_fetch)
{
    Rank &rank_ref = *ranks[0];
    Bank &bank_ref = rank_ref.banks[mem_pkt->bank];
    Tick col_allowed_at = curTick();
    if (pending_to_precharge || bank_ref.openRow != mem_pkt->row) {
        DPRINTF(PIM,
                "Changing mode or in PIM mode with row conflict, current row: "
                "%d, accessed row: %d\n",
                bank_ref.openRow, mem_pkt->row);
        // CHANGE: If we are in all bank mode and PIM mode, we want to
        // precharge all banks in the rank, not just the accessed bank
        for (int i = 0; i < banksPerRank; i++) {
            Bank &bank_ref = rank_ref.banks[i];
            if (bank_ref.openRow != Bank::NO_ROW) {
                prechargeBank(rank_ref, bank_ref,
                              std::max(bank_ref.preAllowedAt, curTick()),
                              true);
            }
            activateBank(rank_ref, bank_ref,
                         std::max(bank_ref.actAllowedAt, curTick()),
                         mem_pkt->row);
            col_allowed_at = std::max(
                col_allowed_at, mem_pkt->isRead() ? bank_ref.rdAllowedAt
                                                  : bank_ref.wrAllowedAt);
        }
        pending_to_precharge = false;
    }
    Tick pim_allowed_at = std::max(col_allowed_at, last_fetch + 4 * tCK);
    Tick end_instr =
        pim_allowed_at + 4 * 5 * tCK; // 4 cycles for each of the 5 stages
    return std::make_pair(pim_allowed_at, end_instr);
}

std::pair<Tick, Tick>
PIMInterface::doBurstAccess(MemPacket* mem_pkt, Tick next_burst_at,
                             const std::vector<MemPacketQueue>& queue)
{
    DPRINTF(PIM, "doBurstAccess called with addr 0x%x, pim_mode=%d\n",
            mem_pkt->getAddr(), pim_mode);
    if(pim_mode){
        if(crf[pc]->is_read()){
            stats.readBursts++;
        }
        else if(crf[pc]->is_write()){
            stats.writeBursts++;
        }
        else{
            assert(crf[pc]->getType() == "JUMP" || crf[pc]->getType() == "EXIT" || crf[pc]->getType() == "NOP");
        }
        Rank &rank_ref = *ranks[0];
        Bank &bank_ref = rank_ref.banks[mem_pkt->bank];
        Tick fetch_allowed_at = std::max(next_burst_at, curTick());
        if (pending_to_precharge || bank_ref.openRow != mem_pkt->row) {
            if(crf[pc]->is_read()){
                stats.read_misses++;
            }
            else if(crf[pc]->is_write()){
                stats.write_misses++;
            }
            DPRINTF(PIM,
                    "Changing mode or in PIM mode with row conflict, current "
                    "row: %d, accessed row: %d\n",
                    bank_ref.openRow, mem_pkt->row);
            // CHANGE: If we are in all bank mode and PIM mode, we want to
            // precharge all banks in the rank, not just the accessed bank
            for (int i = 0; i < banksPerRank; i++) {
                Bank &bank_ref = rank_ref.banks[i];
                if (bank_ref.openRow != Bank::NO_ROW) {
                    prechargeBank(rank_ref, bank_ref,
                                    std::max(bank_ref.preAllowedAt, curTick()),
                                    true);
                }
                activateBank(rank_ref, bank_ref,
                                std::max(bank_ref.actAllowedAt, curTick()),
                                mem_pkt->row);
                fetch_allowed_at = std::max(
                    fetch_allowed_at, crf[pc]->is_read() ? bank_ref.rdAllowedAt - 4 * tCK
                                                         : bank_ref.wrAllowedAt -
                                                           4 * tCK);
            }
        }
        else{
            if(crf[pc]->is_read()){
                stats.read_hits++;
            }
            else if(crf[pc]->is_write()){
                stats.write_hits++;
            }
        }
        //Tick pim_allowed_at = std::max(col_allowed_at, last_fetch + 4 * tCK);
        //col_allowed_at = std::max(col_allowed_at, next_burst_at);
        bool is_exit = (crf[pc]->getType() == "EXIT");
        Tick next_instr = fetch_allowed_at + (is_exit ? 4 * 5 * tCK : 4 * tCK);
        mem_pkt->readyTime = curTick();
        DPRINTF(PIM_PIPELINE, "Instruction with addr 0x%x starts at %d, next at %d\n",
                mem_pkt->getAddr(), fetch_allowed_at, next_instr);
        
        if(mem_pkt->isRead()){
            ++rank_ref.outstandingEvents;
        }
        if(!pending_to_precharge){
            ++pim_stats.total_gaps_between_instrs;
            pim_stats.total_ticks_between_instrs += (fetch_allowed_at - last_fetch);
            pim_stats.hist_ticks_between_instrs.sample(fetch_allowed_at - last_fetch);
        }
        last_fetch = fetch_allowed_at;
        pending_to_precharge = false;
        return std::make_pair(curTick(), next_instr);
    }
    else{
        return DRAMInterface::doBurstAccess(mem_pkt, next_burst_at, queue);
    }

}

bool
PIMInterface::isPIMAddr(Addr addr)
{
    return addr == pim_range_start || addr == pim_range_start + 4 ||
           crf_range.contains(addr) || pu_range.contains(addr);
}

void
PIMInterface::access(PacketPtr pkt)
{
    bool response_done = false;
    //DPRINTF(PIM, "PIMInterface::access called with addr 0x%x, pim_mode=%d\n",
    //        pkt->getAddr(), pim_mode);
    if (pim_mode) {
        executeKernel(pkt);
    } else {
        Addr addr = pkt->getAddr();
        // skip pim and single bank registers, 32 bits per CRF entry, 
        size_t srf_size = srf_entries * 2; // 16 bits per scalar register
        size_t grf_size =
            grf_entries * simd_width * 2; // 16 bits per vector register entry
        if (addr == pim_range_start) {
            // Access PIM mode register
            pim_mode = true;
            pending_to_precharge = true;
            pc = 0;
            for (PIMInterface::PIMInstruction *i : crf) {
                if (i == NULL) {
                    break;
                }
                i->rst();
            }
            pim_stats.pim_mode_switches++;
            pim_stats.pim_conf_accesses++;
            DPRINTF(PIM, "Entering PIM mode\n");
        } else if (addr == pim_range_start + 4) {
            // Access all bank mode register
            all_bank_mode = !all_bank_mode;
            pim_stats.all_bank_mode_switches++;
            pim_stats.pim_conf_accesses++;
            DPRINTF(PIM, "Setting all bank mode to %d\n", all_bank_mode);
        } else if (crf_range.contains(addr)) {
            // Access CRF
            int idx = (addr - crf_range.start()) / 4;
            uint32_t raw_instr = *(pkt->getConstPtr<uint32_t>());
            crf[idx] = format_instruction(raw_instr);
            DPRINTF(PIM, "Loaded instruction %s into CRF index %d\n",
                    crf[idx]->getType(), idx);
            if (pkt->isWrite()) {
                pim_stats.crf_writes++;
            } else {
                pim_stats.crf_reads++;
            }
            pim_stats.pim_conf_accesses++;
        } else if (pu_range.contains(addr)) {
            pim_stats.pim_conf_accesses++;
            // Get PU index
            uint8_t pu_idx = (addr - crf_range.end()) / (srf_size + grf_size);
            if (pu_idx >= processing_units.size()) {
                panic(
                    "PU index %d out of bounds for processing units size %d\n",
                    pu_idx, processing_units.size());
            }
            // See if it's an SRF or GRF access within the PU
            Addr pu_base = crf_range.end() + pu_idx * (srf_size + grf_size);
            AddrRange pu_srf_range = AddrRange(pu_base, pu_base + srf_size);
            AddrRange pu_grf_range =
                AddrRange(pu_srf_range.end(), pu_srf_range.end() + grf_size);
            if (pu_srf_range.contains(addr)) {
                // Access SRF
                int idx = (addr - pu_srf_range.start()) / 2;
                uint16_t val = *(pkt->getConstPtr<uint16_t>());
                if (pkt->isWrite()) {
                    pim_stats.srf_writes++;
                } else {
                    pim_stats.srf_reads++;
                }
                if (idx < processing_units[pu_idx].srf_m.size()) {
                    DPRINTF(
                        PIM,
                        "Access to SRF_M at index %d in PU %d with value %d\n",
                        idx, pu_idx, val);
                    for (int i = 0; i < simd_width; ++i) {
                        processing_units[pu_idx].srf_m[idx][i] = val;
                    }
                } else if (idx < processing_units[pu_idx].srf_m.size() +
                                     processing_units[pu_idx].srf_a.size()) {
                    idx -= processing_units[pu_idx].srf_m.size();
                    DPRINTF(
                        PIM,
                        "Access to SRF_A at index %d in PU %d with value %d\n",
                        idx, pu_idx, val);
                    for (int i = 0; i < simd_width; ++i) {
                        processing_units[pu_idx].srf_a[idx][i] = val;
                    }
                } else {
                    panic("SRF index %d out of bounds for SRF size %d in PU "
                          "%d\n",
                          idx,
                          processing_units[pu_idx].srf_m.size() +
                              processing_units[pu_idx].srf_a.size(),
                          pu_idx);
                }
            } else if (pu_grf_range.contains(addr)) {
                // Access GRF
                DPRINTF(PIM,
                        "Access to GRF at address %#x not implemented yet\n",
                        addr);
                if (pkt->isWrite()) {
                    pim_stats.grf_writes++;
                } else {
                    pim_stats.grf_reads++;
                }
            } else {
                panic(
                    "Address %#x out of bounds for PU %d SRF and GRF ranges\n",
                    addr, pu_idx);
            }
        } else {
            // Address is not in PIM range, access normal DRAM
            //DPRINTF(PIM, "Normal DRAM access at address %#x\n", addr);
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
    pim_stats.crf_reads++;
    // We distingish CONTROL Instruction becasue of the programn counter
    // increment, it could be incremented inside exec, but it would be
    // problematic with all_bank mode
    if (crf[pc]->getType() == "EXIT" || crf[pc]->getType() == "JUMP" ||
        crf[pc]->getType() == "NOP") {
        pim_stats.ctrl_instrs_executed++;
        uint8_t pu = decodeBank(pkt->getAddr()) / 2;
        DPRINTF(PIM, "Executing control instruction %d %s from PU %d\n", pc,
                crf[pc]->getType(), pu);
        crf[pc]->exec(pkt->getAddr(), this, pu, pkt->isWrite());
    } else {
        if (crf[pc]->getType() == "MOV") {
            pim_stats.data_instrs_executed++;
        } else {
            pim_stats.alu_instrs_executed++;
        }
        if (all_bank_mode) {
            uint8_t bank = decodeBank(pkt->getAddr());
            DPRINTF(PIM, "Executing instruction %d %s in all_bank_mode with address %#x\n", pc,
                    crf[pc]->getType(), pkt->getAddr());
            for (uint8_t pu = 0; pu < processing_units.size(); ++pu) {
                Addr addr = modifyAddrForBank(
                    pkt->getAddr(), bank); // Modify address to target the
                                           // correct bank for this PU
                crf[pc]->exec(addr, this, pu, pkt->isWrite());
                bank += 2;
            }
        } else {
            uint8_t pu = decodeBank(pkt->getAddr()) / 2;
            DPRINTF(PIM, "Executing instruction %d %s from PU %d\n", pc,
                    crf[pc]->getType(), pu);
            crf[pc]->exec(pkt->getAddr(), this, pu, pkt->isWrite());
        }
        ++pc;
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
    : PIMInstruction(_type), imm0(_imm0), imm1(_imm1), cnt(0)
{}

void
PIMInterface::ControlInstruction::exec(Addr addr, PIMInterface *pim,
                                       uint8_t pu, bool is_write)
{
    switch (type) {
        case NOP:
            pim->incrementPC();
            break;
        case JUMP:
            if (cnt < imm1) {
                pim->decrementPC(imm0);
                ++cnt;
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


void
PIMInterface::ControlInstruction::rst()
{ cnt = 0; }

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
PIMInterface::DataInstruction::exec(Addr addr, PIMInterface *pim, uint8_t pu,
                                    bool is_write)
{
    int16_t *src0_vector = pim->getVector(pu, src0, src0_idx, addr, is_write);
    int16_t *dest_vector = pim->getVector(pu, dest, dest_idx, addr, is_write);
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
}

bool
PIMInterface::DataInstruction::is_read(){
    return src0 == ODD_BANK || src0 == EVEN_BANK;
}

bool
PIMInterface::DataInstruction::is_write(){
    return dest == ODD_BANK || dest == EVEN_BANK;
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
PIMInterface::ALUInstruction::exec(Addr addr, PIMInterface *pim, uint8_t pu,
                                   bool is_write)
{
    int16_t *op0_vector = pim->getVector(pu, src0, src0_idx, addr, is_write);
    int16_t *op1_vector = pim->getVector(pu, src1, src1_idx, addr, is_write);
    int16_t *dest_vector = pim->getVector(pu, dest, dest_idx, addr, is_write);
    int16_t *op2_vector = pim->getVector(pu, src2, src1_idx, addr,
                                         is_write); // src2 uses src1_idx

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
}

bool
PIMInterface::ALUInstruction::is_read(){
    return src0 == ODD_BANK || src0 == EVEN_BANK || src1 == ODD_BANK || src1 == EVEN_BANK;
}

bool
PIMInterface::ALUInstruction::is_write(){
    return dest == ODD_BANK || dest == EVEN_BANK;
}

} // namespace memory
} // namespace gem5
