#include "mem/pim_interface.hh"

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
                        Addr addr)
{
    PIMInterface::PIMProcessingUnit &pu_ref = processing_units[pu];
    uint8_t bank = decodeBank(addr);
    switch (op_type) {
        case NONE:
            return NULL;
        case GRF_A:
            return &(pu_ref.grf_a[op_idx][0]);
        case GRF_B:
            return &(pu_ref.grf_b[op_idx][0]);
        case SRF_M:
            return &(pu_ref.srf_m[op_idx][0]);
        case SRF_A:
            return &(pu_ref.srf_a[op_idx][0]);
        case ODD_BANK:
            DPRINTF(PIM, "Decoding address %#x to bank %d for PU %d\n", addr,
                    bank, pu);
            assert(bank == 2 * pu);
            return (int16_t *)toHostAddr(addr);
        case EVEN_BANK:
            DPRINTF(PIM, "Decoding address %#x to bank %d for PU %d\n", addr,
                    bank, pu);
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

std::pair<Tick, Tick>
PIMInterface::doBurstAccess(MemPacket *mem_pkt, Tick next_burst_at,
                            const std::vector<MemPacketQueue> &queue)
{
    DPRINTF(PIM, "Timing access to addr %#x, rank/bank/row %d %d %d\n",
            mem_pkt->addr, mem_pkt->rank, mem_pkt->bank, mem_pkt->row);

    // get the rank
    Rank &rank_ref = *ranks[mem_pkt->rank];

    assert(rank_ref.inRefIdleState());

    // are we in or transitioning to a low-power state and have not scheduled
    // a power-up event?
    // if so, wake up from power down to issue RD/WR burst
    if (rank_ref.inLowPowerState) {
        assert(rank_ref.pwrState != PWR_SREF);
        rank_ref.scheduleWakeUpEvent(tXP);
    }

    // for the state we need to track if it is a row hit or not
    bool row_hit = true;

    // get the bank
    Bank &bank_ref = rank_ref.banks[mem_pkt->bank];

    // CHANGE: If we are changing mode or in PIM mode and there is a row
    // conflict, we need to precharge all banks in the rank and activate the
    // new row
    Tick col_allowed_at;
    if (pending_to_precharge ||
        (all_bank_mode && pim_mode && bank_ref.openRow != mem_pkt->row)) {
        DPRINTF(PIM,
                "Changing mode or in PIM mode with row conflict, precharging "
                "all banks in rank %d\n",
                mem_pkt->rank);
        row_hit = false;
        // CHANGE: If we are in all bank mode and PIM mode, we want to
        // precharge all banks in the rank, not just the accessed bank
        Tick max_col_allowed_at = curTick();
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
            max_col_allowed_at = std::max(
                max_col_allowed_at, mem_pkt->isRead() ? bank_ref.rdAllowedAt
                                                      : bank_ref.wrAllowedAt);
        }
        col_allowed_at = max_col_allowed_at;
        pending_to_precharge = false;
    }
    // Determine the access latency and update the bank state
    else {
        if (bank_ref.openRow == mem_pkt->row) {
            // nothing to do
        } else {
            row_hit = false;

            // If there is a page open, precharge it.
            if (bank_ref.openRow != Bank::NO_ROW) {
                prechargeBank(rank_ref, bank_ref,
                              std::max(bank_ref.preAllowedAt, curTick()));
            }

            // next we need to account for the delay in activating the page
            Tick act_tick = std::max(bank_ref.actAllowedAt, curTick());
            activateBank(rank_ref, bank_ref, act_tick, mem_pkt->row);
        }
        // respect any constraints on the command (e.g. tRCD or tCCD)
        col_allowed_at =
            mem_pkt->isRead() ? bank_ref.rdAllowedAt : bank_ref.wrAllowedAt;
    }

    // we need to wait until the bus is available before we can issue
    // the command; need to ensure minimum bus delay requirement is met
    Tick cmd_at = std::max({col_allowed_at, next_burst_at, curTick()});

    // verify that we have command bandwidth to issue the burst
    // if not, shift to next burst window
    Tick max_sync = clkResyncDelay + (mem_pkt->isRead() ? tRL : tWL);
    if (dataClockSync && ((cmd_at - rank_ref.lastBurstTick) > max_sync)) {
        cmd_at = ctrl->verifyMultiCmd(cmd_at, maxCommandsPerWindow, tCK);
    } else {
        cmd_at = ctrl->verifySingleCmd(cmd_at, maxCommandsPerWindow, false);
    }

    // CHANGE: When we are in PIM mode, we move data internally and we don't
    // need to use the bus
    Tick burst_gap = 0;

    if (!pim_mode) {
        // if we are interleaving bursts, ensure that
        // 1) we don't double interleave on next burst issue
        // 2) we are at an interleave boundary; if not, shift to next boundary
        burst_gap = tBURST_MIN;
        if (burstInterleave) {
            if (cmd_at == (rank_ref.lastBurstTick + tBURST_MIN)) {
                // already interleaving, push next command to end of full burst
                burst_gap = tBURST;
            } else if (cmd_at < (rank_ref.lastBurstTick + tBURST)) {
                // not at an interleave boundary after bandwidth check
                // Shift command to tBURST boundary to avoid data contention
                // Command will remain in the same burst window given that
                // tBURST is less than tBURST_MAX
                cmd_at = rank_ref.lastBurstTick + tBURST;
            }
        }
    }

    DPRINTF(PIM, "Schedule RD/WR burst at tick %d\n", cmd_at);

    // CHANGE: PIM Pipeline delay
    // TO-DO: Parameter cycles
    Tick pim_pipeline_delay = pim_mode ? (5 * tCK) : 0;

    // update the packet ready time
    if (mem_pkt->isRead()) {
        mem_pkt->readyTime = cmd_at + tRL + tBURST + pim_pipeline_delay;
    } else {
        mem_pkt->readyTime = cmd_at + tWL + tBURST + pim_pipeline_delay;
    }

    rank_ref.lastBurstTick = cmd_at;

    // update the time for the next read/write burst for each
    // bank (add a max with tCCD/tCCD_L/tCCD_L_WR here)
    Tick dly_to_rd_cmd;
    Tick dly_to_wr_cmd;
    for (int j = 0; j < ranksPerChannel; j++) {
        for (int i = 0; i < banksPerRank; i++) {
            if (mem_pkt->rank == j) {
                if (bankGroupArch &&
                    (bank_ref.bankgr == ranks[j]->banks[i].bankgr ||
                     (all_bank_mode &&
                      pim_mode))) { // CHANGE: Now we enter here if we are in
                                    // pim_mode all_bank_mode
                    // bank group architecture requires longer delays between
                    // RD/WR burst commands to the same bank group.
                    // tCCD_L is default requirement for same BG timing
                    // tCCD_L_WR is required for write-to-write
                    // Need to also take bus turnaround delays into account
                    dly_to_rd_cmd = mem_pkt->isRead()
                                        ? tCCD_L
                                        : std::max(tCCD_L, wrToRdDlySameBG);
                    dly_to_wr_cmd = mem_pkt->isRead()
                                        ? std::max(tCCD_L, rdToWrDlySameBG)
                                        : tCCD_L_WR;
                } else {
                    // tBURST is default requirement for diff BG timing
                    // Need to also take bus turnaround delays into account
                    dly_to_rd_cmd =
                        mem_pkt->isRead() ? burst_gap : writeToReadDelay();
                    dly_to_wr_cmd =
                        mem_pkt->isRead() ? readToWriteDelay() : burst_gap;
                }
            } else {
                // different rank is by default in a different bank group and
                // doesn't require longer tCCD or additional RTW, WTR delays
                // Need to account for rank-to-rank switching
                dly_to_wr_cmd = rankToRankDelay();
                dly_to_rd_cmd = rankToRankDelay();
            }
            ranks[j]->banks[i].rdAllowedAt = std::max(
                cmd_at + dly_to_rd_cmd, ranks[j]->banks[i].rdAllowedAt);
            ranks[j]->banks[i].wrAllowedAt = std::max(
                cmd_at + dly_to_wr_cmd, ranks[j]->banks[i].wrAllowedAt);
        }
    }

    // Save rank of current access
    activeRank = mem_pkt->rank;

    bool auto_precharge = pageMgmt == enums::close;

    // CHANGE: If we are in all bank mode and PIM mode, we want to update the
    // state of all banks in the rank, not just the accessed bank
    if (all_bank_mode && pim_mode) {
        for (int i = 0; i < banksPerRank; i++) {
            Bank &bank_ref = rank_ref.banks[i];
            bank_ref.preAllowedAt = std::max(
                bank_ref.preAllowedAt,
                mem_pkt->isRead() ? cmd_at + tRTP : mem_pkt->readyTime + tWR);
            bank_ref.bytesAccessed += burstSize;
            ++bank_ref.rowAccesses;
            auto_precharge |= bank_ref.rowAccesses == maxAccessesPerRow;
        }
    } else {
        // If this is a write, we also need to respect the write recovery
        // time before a precharge, in the case of a read, respect the
        // read to precharge constraint
        bank_ref.preAllowedAt = std::max(
            bank_ref.preAllowedAt,
            mem_pkt->isRead() ? cmd_at + tRTP : mem_pkt->readyTime + tWR);

        // increment the bytes accessed and the accesses per row
        bank_ref.bytesAccessed += burstSize;
        ++bank_ref.rowAccesses;
        // if we reached the max, then issue with an auto-precharge
        auto_precharge = pageMgmt == enums::close ||
                         bank_ref.rowAccesses == maxAccessesPerRow;
    }

    // if we did not hit the limit, we might still want to
    // auto-precharge
    if (!auto_precharge && (pageMgmt == enums::open_adaptive ||
                            pageMgmt == enums::close_adaptive)) {
        // a twist on the open and close page policies:
        // 1) open_adaptive page policy does not blindly keep the
        // page open, but close it if there are no row hits, and there
        // are bank conflicts in the queue
        // 2) close_adaptive page policy does not blindly close the
        // page, but closes it only if there are no row hits in the queue.
        // In this case, only force an auto precharge when there
        // are no same page hits in the queue
        bool got_more_hits = false;
        bool got_bank_conflict = false;

        for (uint8_t i = 0; i < ctrl->numPriorities(); ++i) {
            auto p = queue[i].begin();
            // keep on looking until we find a hit or reach the end of the
            // queue
            // 1) if a hit is found, then both open and close adaptive
            //    policies keep the page open
            // 2) if no hit is found, got_bank_conflict is set to true if a
            //    bank conflict request is waiting in the queue
            // 3) make sure we are not considering the packet that we are
            //    currently dealing with
            while (!got_more_hits && p != queue[i].end()) {

                if ((*p)->pseudoChannel != pseudoChannel) {
                    // only consider if this pkt belongs to this interface
                    ++p;
                    continue;
                }

                if (mem_pkt != (*p)) {
                    bool same_rank_bank = (mem_pkt->rank == (*p)->rank) &&
                                          (mem_pkt->bank == (*p)->bank);

                    bool same_row = mem_pkt->row == (*p)->row;
                    got_more_hits |= same_rank_bank && same_row;
                    got_bank_conflict |= same_rank_bank && !same_row;
                }
                ++p;
            }

            if (got_more_hits) {
                break;
            }
        }

        // auto pre-charge when either
        // 1) open_adaptive policy, we have not got any more hits, and
        //    have a bank conflict
        // 2) close_adaptive policy and we have not got any more hits
        auto_precharge = !got_more_hits && (got_bank_conflict ||
                                            pageMgmt == enums::close_adaptive);
    }

    // DRAMPower trace command to be written
    std::string mem_cmd = mem_pkt->isRead() ? "RD" : "WR";

    // MemCommand required for DRAMPower library
    MemCommand::cmds command =
        (mem_cmd == "RD") ? MemCommand::RD : MemCommand::WR;

    rank_ref.cmdList.push_back(Command(command, mem_pkt->bank, cmd_at));

    DPRINTF(DRAMPower, "%llu,%s,%d,%d\n",
            divCeil(cmd_at, tCK) - timeStampOffset, mem_cmd, mem_pkt->bank,
            mem_pkt->rank);

    // if this access should use auto-precharge, then we are
    // closing the row after the read/write burst
    if (auto_precharge) {
        // if auto-precharge push a PRE command at the correct tick to the
        // list used by DRAMPower library to calculate power
        // CHANGE: If we are in all bank mode and PIM mode, we want to
        // precharge all banks in the rank, not just the accessed bank
        if (all_bank_mode && pim_mode) {
            for (int i = 0; i < banksPerRank; i++) {
                Bank &bank_ref = rank_ref.banks[i];
                prechargeBank(rank_ref, bank_ref,
                              std::max(curTick(), bank_ref.preAllowedAt),
                              true);
            }
            DPRINTF(PIM, "Auto-precharged all banks in rank: %d\n",
                    mem_pkt->rank);
        } else {
            prechargeBank(rank_ref, bank_ref,
                          std::max(curTick(), bank_ref.preAllowedAt), true);

            DPRINTF(PIM, "Auto-precharged bank: %d\n", mem_pkt->bankId);
        }
    }

    // Update the stats and schedule the next request
    if (mem_pkt->isRead()) {
        // Every respQueue which will generate an event, increment count
        ++rank_ref.outstandingEvents;

        stats.readBursts++;
        if (row_hit) {
            stats.readRowHits++;
        }
        stats.dramBytesRead += burstSize;
        stats.perBankRdBursts[mem_pkt->bankId]++;

        // Update latency stats
        stats.totMemAccLat += mem_pkt->readyTime - mem_pkt->entryTime;
        stats.totQLat += cmd_at - mem_pkt->entryTime;
        // CHANGE: Only update bus latency when not in PIM mode, as we are
        // moving data internally in PIM mode and not using the bus
        if (!pim_mode) {
            stats.totBusLat += tBURST;
        }
    } else {
        // Schedule write done event to decrement event count
        // after the readyTime has been reached
        // Only schedule latest write event to minimize events
        // required; only need to ensure that final event scheduled covers
        // the time that writes are outstanding and bus is active
        // to holdoff power-down entry events
        if (!rank_ref.writeDoneEvent.scheduled()) {
            schedule(rank_ref.writeDoneEvent, mem_pkt->readyTime);
            // New event, increment count
            ++rank_ref.outstandingEvents;

        } else if (rank_ref.writeDoneEvent.when() < mem_pkt->readyTime) {
            reschedule(rank_ref.writeDoneEvent, mem_pkt->readyTime);
        }
        // will remove write from queue when returned to parent function
        // decrement count for DRAM rank
        --rank_ref.writeEntries;

        stats.writeBursts++;
        if (row_hit) {
            stats.writeRowHits++;
        }
        stats.dramBytesWritten += burstSize;
        stats.perBankWrBursts[mem_pkt->bankId]++;
    }
    // Update bus state to reflect when previous command was issued
    return std::make_pair(cmd_at, cmd_at + burst_gap);
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
        AddrRange crf_range = AddrRange(pim_range_start + 8,
                                        pim_range_start + 8 + crf_entries * 4);
        size_t srf_size = srf_entries * 2; // 16 bits per scalar register
        size_t grf_size =
            grf_entries * simd_width * 2; // 16 bits per vector register entry
        AddrRange pu_range = AddrRange(
            crf_range.end(),
            crf_range.end() + processing_units.size() * (srf_size + grf_size));
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
            DPRINTF(PIM, "Entering PIM mode\n");
        } else if (addr == pim_range_start + 4) {
            // Access all bank mode register
            all_bank_mode = !all_bank_mode;
            DPRINTF(PIM, "Setting all bank mode to %d\n", all_bank_mode);
        } else if (crf_range.contains(addr)) {
            // Access CRF
            int idx = (addr - crf_range.start()) / 4;
            uint32_t raw_instr = *(pkt->getConstPtr<uint32_t>());
            crf[idx] = format_instruction(raw_instr);
            DPRINTF(PIM, "Loaded instruction %s into CRF index %d\n",
                    crf[idx]->getType(), idx);
        } else if (pu_range.contains(addr)) {
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
            } else {
                panic(
                    "Address %#x out of bounds for PU %d SRF and GRF ranges\n",
                    addr, pu_idx);
            }
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
    // We distingish CONTROL Instruction becasue of the programn counter
    // increment, it could be incremented inside exec, but it would be
    // problematic with all_bank mode
    if (crf[pc]->getType() == "EXIT" || crf[pc]->getType() == "JUMP" ||
        crf[pc]->getType() == "NOP") {
        uint8_t pu = decodeBank(pkt->getAddr()) / 2;
        DPRINTF(PIM, "Executing control instruction %d %s from PU %d\n", pc,
                crf[pc]->getType(), pu);
        crf[pc]->exec(pkt->getAddr(), this, pu);
    } else {
        if (all_bank_mode) {
            uint8_t bank = decodeBank(pkt->getAddr());
            for (uint8_t pu = 0; pu < processing_units.size(); ++pu) {
                DPRINTF(PIM, "Executing instruction %d %s from PU %d\n", pc,
                        crf[pc]->getType(), pu);
                Addr addr = modifyAddrForBank(
                    pkt->getAddr(), bank); // Modify address to target the
                                           // correct bank for this PU
                crf[pc]->exec(addr, this, pu);
                bank += 2;
            }
        } else {
            uint8_t pu = decodeBank(pkt->getAddr()) / 2;
            DPRINTF(PIM, "Executing instruction %d %s from PU %d\n", pc,
                    crf[pc]->getType(), pu);
            crf[pc]->exec(pkt->getAddr(), this, pu);
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
                                       uint8_t pu)
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
{
    cnt = 0;
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
PIMInterface::DataInstruction::exec(Addr addr, PIMInterface *pim, uint8_t pu)
{
    int16_t *src0_vector = pim->getVector(pu, src0, src0_idx, addr);
    int16_t *dest_vector = pim->getVector(pu, dest, dest_idx, addr);
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
PIMInterface::ALUInstruction::exec(Addr addr, PIMInterface *pim, uint8_t pu)
{
    int16_t *op0_vector = pim->getVector(pu, src0, src0_idx, addr);
    int16_t *op1_vector = pim->getVector(pu, src1, src1_idx, addr);
    int16_t *dest_vector = pim->getVector(pu, dest, dest_idx, addr);
    int16_t *op2_vector =
        pim->getVector(pu, src2, src1_idx, addr); // src2 uses src1_idx

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

} // namespace memory
} // namespace gem5
