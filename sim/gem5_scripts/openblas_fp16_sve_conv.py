"""Run the OpenBLAS FP16/SVE convolution baseline in gem5 SE mode."""

from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent))
from env_params import int_env

from gem5.components.boards.simple_board import SimpleBoard
from gem5.components.cachehierarchies.classic.private_l1_shared_l2_cache_hierarchy import (
    PrivateL1SharedL2CacheHierarchy,
)
from gem5.components.memory import SingleChannelDDR4_2400
from gem5.components.processors.cpu_types import CPUTypes
from gem5.components.processors.simple_processor import SimpleProcessor
from gem5.isas import ISA
from gem5.resources.resource import BinaryResource
from gem5.simulate.simulator import Simulator
from gem5.utils.requires import requires


requires(isa_required=ISA.ARM)

repo_root = Path(__file__).resolve().parents[2]
binary = repo_root / "kernels" / "build" / "openblas_fp16_sve_conv_cpu"
arguments = [
    str(int_env("CONV_H", minimum=1)),
    str(int_env("CONV_W", minimum=1)),
    str(int_env("CONV_C", minimum=1)),
    str(int_env("CONV_KH", minimum=1)),
    str(int_env("CONV_KW", minimum=1)),
    str(int_env("CONV_OC", minimum=1)),
    str(int_env("CONV_PRINT", minimum=0)),
]

processor = SimpleProcessor(
    cpu_type=CPUTypes.MINOR,
    isa=ISA.ARM,
    num_cores=1,
)

cache_hierarchy = PrivateL1SharedL2CacheHierarchy(
    l1d_size="32KiB",
    l1d_assoc=8,
    l1i_size="32KiB",
    l1i_assoc=8,
    l2_size="512KiB",
    l2_assoc=16,
)

board = SimpleBoard(
    clk_freq="3GHz",
    processor=processor,
    memory=SingleChannelDDR4_2400(size="512MiB"),
    cache_hierarchy=cache_hierarchy,
)

board.set_se_binary_workload(
    BinaryResource(str(binary)),
    env_list=["OPENBLAS_NUM_THREADS=1", "OMP_NUM_THREADS=1"],
    arguments=arguments,
)
Simulator(board=board).run()
