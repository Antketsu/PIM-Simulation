class PIMInterface(DRAMInterface):
    type = "PIMInterface"
    cxx_header = "mem/pim_interface.hh"
    cxx_class = "gem5::memory::PIMInterface"

    crf_entries = Param.Unsigned(
        32, "Number of entries in the instruction register file"
    )
    grf_entries = Param.Unsigned(
        32, "Number of entries in the vector register file"
    )
    srf_entries = Param.Unsigned(
        16, "Number of entries in the scalar register file"
    )
    simd_width = Param.Unsigned(
        8, "Number of elements processed in parallel in SIMD operations"
    )
