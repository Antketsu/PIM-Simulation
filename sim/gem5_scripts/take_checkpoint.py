"""Boot the PIM full-system guest with MINOR and save a boot checkpoint."""

from pathlib import Path

from gem5.components.boards.pim_board import PIMBoard
from gem5.components.cachehierarchies.classic.private_l1_shared_l2_cache_hierarchy import (
    PrivateL1SharedL2CacheHierarchy,
)
from gem5.components.memory.single_channel import SingleChannelDDR4_2400
from gem5.components.memory.pim import PIMAccelerator
from gem5.components.processors.cpu_types import CPUTypes
from gem5.components.processors.simple_processor import SimpleProcessor
from gem5.components.processors.simple_switchable_processor import SimpleSwitchableProcessor
from gem5.isas import ISA
from gem5.resources.resource import DiskImageResource
from gem5.simulate.exit_event import ExitEvent
from gem5.simulate.simulator import Simulator


cache_hierarchy = PrivateL1SharedL2CacheHierarchy(
    l1d_size="32kB",
    l1d_assoc=8,
    l1i_size="32kB",
    l1i_assoc=8,
    l2_size="512kB",
    l2_assoc=16,
)
memory = SingleChannelDDR4_2400(size="3GB")
processor = SimpleProcessor(cpu_type=CPUTypes.KVM, isa=ISA.X86, num_cores=1)

for proc in processor.get_cores():
  proc.core.usePerf = False

pim = PIMAccelerator(size="3GB")
board = PIMBoard(
    clk_freq="1GHz",
    processor=processor,
    memory=memory,
    cache_hierarchy=cache_hierarchy,
    pim=pim,
)

board.set_kernel_disk_workload(
    kernel=DiskImageResource(
        "/homelocal/antoma19_local/u/PIM-Simulation/gem5-resources/src/ubuntu-generic-diskimages/x86-disk-image-24-04/vmlinux-x86-ubuntu"
    ),
    disk_image=DiskImageResource(
        "/homelocal/antoma19_local/u/PIM-Simulation/gem5-resources/src/ubuntu-generic-diskimages/x86-disk-image-24-04/x86-ubuntu"
    ),
    # Stop gem5 at this m5 exit after the guest has booted. The checkpoint
    # resumes at /bin/sh, after the exit instruction.
    readfile_contents="m5 exit; /bin/sh;",
    kernel_args=[
        "earlyprintk=ttyS0",
        "console=ttyS0",
        "root=/dev/sda2",
        "memmap=3G$0x280000000",
    ],
)


def exit_event_handler():
    simulator.save_checkpoint("cpt")
    print("Taking checkpoint")
    yield True


simulator = Simulator(
    board=board,
    on_exit_event={ExitEvent.EXIT: exit_event_handler()},
)
simulator.run()
