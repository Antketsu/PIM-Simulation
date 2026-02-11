from m5.objects.MemCtrl import *
from m5.params import *


class PIMCtrl(MemCtrl):
    type = "PIMCtrl"
    cxx_header = "mem/pim_ctrl.hh"
    cxx_class = "gem5::memory::PIMCtrl"
