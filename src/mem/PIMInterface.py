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
        8, "Number of elements processed in parallel in SIMD operations"
    )
    pim_range_start = Param.Addr(
        0x100000000, "Starting address of the PIM register address range"
    )
