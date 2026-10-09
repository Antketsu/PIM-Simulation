from m5.objects.DRAMInterface import DRAMInterface
from m5.params import *


class PIMInterface(DRAMInterface):
    type = "PIMInterface"
    cxx_header = "mem/pim_interface.hh"
    cxx_class = "gem5::memory::PIMInterface"

    crf_entries = Param.Unsigned(
        32, "Number of entries in the instruction register file"
    )
    grf_entries = Param.Unsigned(
        16, "Number of entries in the vector register file"
    )
    srf_entries = Param.Unsigned(
        16, "Number of entries in the scalar register file"
    )
    simd_width = Param.Unsigned(
        16, "Number of elements processed in parallel in SIMD operations"
    )
    # By default 4GB
    pim_range_start = Param.Addr(
        0x280000000, "Starting address of the PIM register address range"
    )

    # 64-bit interface for a single pseudo channel
    device_bus_width = 64

    # HBM2 supports BL4
    burst_length = 4

    # size of channel in bytes, 4H stack of 8Gb dies is 4GiB per stack;
    # with 16 pseudo channels, 256MiB per pseudo channel
    device_size = "256MiB"

    device_rowbuffer_size = "1KiB"

    # 1x128 configuration
    devices_per_rank = 1

    ranks_per_channel = 1

    banks_per_rank = 16
    bank_groups_per_rank = 4

    # 1000 MHz for 2Gbps DDR data rate
    tCK = "1ns"

    tRP = "14ns"

    tCCD_L = "3ns"

    tRCD = "12ns"
    tRCD_WR = "6ns"
    tCL = "18ns"
    tCWL = "7ns"
    tRAS = "28ns"

    # BL4 in pseudo channel mode
    # DDR @ 1000 MHz means 4 * 1ns / 2 = 2ns
    tBURST = "2ns"

    # value for 2Gb device from JEDEC spec
    tRFC = "220ns"

    # value for 2Gb device from JEDEC spec
    tREFI = "3.9us"

    tWR = "14ns"
    tRTP = "5ns"
    tWTR = "4ns"
    tWTR_L = "9ns"
    tRTW = "18ns"

    # tAAD from RBus
    tAAD = "1ns"

    # single rank device, set to 0
    tCS = "0ns"

    tRRD = "4ns"
    tRRD_L = "6ns"

    # for a single pseudo channel
    tXAW = "16ns"
    activation_limit = 4

    # 4tCK
    tXP = "8ns"

    # start with tRFC + tXP -> 160ns + 8ns = 168ns
    tXS = "216ns"

    page_policy = "close_adaptive"

    read_buffer_size = 64
    write_buffer_size = 64

    two_cycle_activate = True
