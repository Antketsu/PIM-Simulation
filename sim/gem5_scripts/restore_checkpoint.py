"""Restore the MINOR full-system boot checkpoint and continue in the guest."""

import argparse
from pathlib import Path

from gem5.components.boards.pim_board import PIMBoard
from gem5.components.cachehierarchies.classic.private_l1_shared_l2_cache_hierarchy import (
    PrivateL1SharedL2CacheHierarchy,
)
from gem5.components.memory.single_channel import SingleChannelDDR4_2400
from gem5.components.memory.pim import PIMAccelerator
from gem5.components.processors.cpu_types import CPUTypes
from gem5.components.processors.simple_processor import SimpleProcessor
from gem5.isas import ISA
from gem5.resources.resource import DiskImageResource
from gem5.simulate.simulator import Simulator


parser = argparse.ArgumentParser()
parser.add_argument(
    "--checkpoint-path",
    type=Path,
    default=Path("cpt"),
    help="Directory containing the checkpoint made by checkpoint_minor.py.",
)
args = parser.parse_args()
if not (args.checkpoint_path / "m5.cpt").is_file():
    parser.error(f"No m5.cpt found in {args.checkpoint_path}")

cache_hierarchy = PrivateL1SharedL2CacheHierarchy(
    l1d_size="32kB",
    l1d_assoc=8,
    l1i_size="32kB",
    l1i_assoc=8,
    l2_size="512kB",
    l2_assoc=16,
)
memory = SingleChannelDDR4_2400(size="3GB")
processor = SimpleProcessor(
    cpu_type=CPUTypes.O3,
    isa=ISA.X86,
    num_cores=1,
)
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
    kernel_args=[
        "earlyprintk=ttyS0",
        "console=ttyS0",
        "root=/dev/sda2",
        "memmap=3G$0x280000000",
    ],
    checkpoint=args.checkpoint_path,
)

simulator = Simulator(board=board)
print(f"Restoring MINOR boot checkpoint from {args.checkpoint_path}")
simulator.run()
