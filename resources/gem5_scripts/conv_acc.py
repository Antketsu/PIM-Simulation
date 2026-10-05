import argparse

from gem5.components.boards.pim_board import PIMBoard
from gem5.components.cachehierarchies.classic.private_l1_shared_l2_cache_hierarchy import (
    PrivateL1SharedL2CacheHierarchy,
)
from gem5.components.memory.pim import PIMAccelerator
from gem5.components.memory.single_channel import SingleChannelDDR4_2400
from gem5.components.processors.cpu_types import CPUTypes
from gem5.components.processors.simple_processor import SimpleProcessor
from gem5.isas import ISA
from gem5.resources.resource import BinaryResource
from gem5.simulate.exit_event import ExitEvent
from gem5.simulate.simulator import Simulator


def parse_args():
    parser = argparse.ArgumentParser(
        description="Run the im2col convolution binary with the PIM accelerator."
    )
    parser.add_argument("input_height", type=int)
    parser.add_argument("input_width", type=int)
    parser.add_argument("input_channels", type=int)
    parser.add_argument("kernel_height", type=int)
    parser.add_argument("kernel_width", type=int)
    parser.add_argument("output_channels", type=int)
    parser.add_argument("print_result", type=int, nargs="?", default=1)
    return parser.parse_args()


def exit_handler():
    process = processor.get_cores()[0].core.workload[0]
    # VA, PA, Size, Cacheable
    process.map(0x10000000, 0xC4000000, 0x1000000, False)  # PIM region
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

memory = SingleChannelDDR4_2400(size="3GB")
processor = SimpleProcessor(num_cores=1, isa=ISA.ARM, cpu_type=CPUTypes.MINOR)
pim = PIMAccelerator(size="3GB")

board = PIMBoard(
    clk_freq="1GHz",
    processor=processor,
    memory=memory,
    cache_hierarchy=cache_hierarchy,
    pim=pim,
)

args = parse_args()
kernel_path = (
    "/homelocal/antoma19_local/u/PIM-Simulation/"
    "resources/binaries/acc/conv"
)

board.set_se_binary_workload(
    binary=BinaryResource(kernel_path),
    arguments=[
        str(args.input_height),
        str(args.input_width),
        str(args.input_channels),
        str(args.kernel_height),
        str(args.kernel_width),
        str(args.output_channels),
        str(args.print_result),
    ],
)

handler = exit_handler()
simulator = Simulator(
    board=board,
    on_exit_event={ExitEvent.EXIT: handler},
)

print(f"Running {kernel_path}")
simulator.run()
