import argparse


#from gem5.components.boards.x86_board import X86Board
from gem5.components.boards.simple_board import SimpleBoard
from gem5.components.cachehierarchies.classic.private_l1_shared_l2_cache_hierarchy import (
    PrivateL1SharedL2CacheHierarchy
)
from gem5.components.cachehierarchies.classic.no_cache import NoCache
from gem5.components.memory.single_channel import SingleChannelDDR4_2400
from gem5.components.memory.hbm import HBM2Stack
from gem5.components.processors.cpu_types import CPUTypes
from gem5.isas import ISA
from gem5.resources.resource import obtain_resource
from gem5.simulate.simulator import Simulator
from gem5.resources.resource import Resource, DiskImageResource
from gem5.simulate.exit_event import ExitEvent
from gem5.components.boards.pim_board import PIMBoard
from gem5.components.boards.x86_board import X86Board
from gem5.components.processors.simple_processor import SimpleProcessor
from gem5.components.processors.simple_switchable_processor import SimpleSwitchableProcessor
from gem5.resources.resource import BinaryResource  
from gem5.components.memory.pim import PIMAccelerator

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--rows", type=int, help="number of rows")
    parser.add_argument("--cols", type=int, help="number of columns")
    args = parser.parse_args()
    return args


def exit_handler():
    process = processor.get_cores()[0].core.workload[0]
    # VA, PA, Size, Cacheable
    process.map(0x10000000, 0xC4000000, 0x1000000, False) # PIM region
    print("Mapped memory region at VA 0x10000000 to PA 0xC4000000")

    process.map(0x20000000, 0xD0000000, 0xFFFFFFF, False)

    yield False
    yield True


cache_hierarchy = PrivateL1SharedL2CacheHierarchy(
    l1d_size="32kB",
    l1d_assoc=8,
    l1i_size="32kB",
    l1i_assoc=8,
    l2_size="512kB",
    l2_assoc=16,
)

# Setup the system memory.
memory = SingleChannelDDR4_2400(size="3GB")


processor = SimpleSwitchableProcessor(
	starting_core_type=CPUTypes.KVM,
	switch_core_type=CPUTypes.TIMING,
	isa=ISA.X86,
	num_cores=1)

for proc in processor.start:
  proc.core.usePerf = False

pim = PIMAccelerator(size="3GB")

board = PIMBoard(
    clk_freq="1GHz",
    processor=processor,
    memory=memory,
    cache_hierarchy=cache_hierarchy,
    pim=pim
)

args = parse_args()

command = (
     "/bin/sh;"
)

def exit_event_handler():
    print('second exit event: In after boot')
    processor.switch()
    print('Switched to timing core')
    yield False
    print('third exit event: After run script')
    yield True

board.set_kernel_disk_workload(
    #kernel=obtain_resource(resource_id="x86-linux-kernel-5.15.180"),
    kernel = DiskImageResource("/home/antonio/U/drivers_course/linux/vmlinux"),
    disk_image=DiskImageResource("/home/antonio/U/laburo/gem5-resources/src/ubuntu-generic-diskimages/x86-disk-image-24-04/x86-ubuntu"),
    readfile_contents=command,
    kernel_args=[
        "earlyprintk=ttyS0",
        "console=ttyS0",
        # "lpj=7999923",
        "root=/dev/sda2",
        #"no_systemd=true",
        "memmap=3G$0x280000000"
    ]
)



simulator = Simulator(
        board=board,
        on_exit_event= {
            ExitEvent.EXIT: exit_event_handler(),
            }
    )

    
simulator.run()