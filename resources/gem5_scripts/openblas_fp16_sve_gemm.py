"""Run the OpenBLAS FP16/SVE example in gem5 syscall-emulation mode."""

from pathlib import Path
import os

from gem5.components.boards.simple_board import SimpleBoard
from gem5.components.cachehierarchies.classic.no_cache import NoCache
from gem5.components.memory import SingleChannelDDR4_2400
from gem5.components.processors.cpu_types import CPUTypes
from gem5.components.processors.simple_processor import SimpleProcessor
from gem5.isas import ISA
from gem5.resources.resource import BinaryResource
from gem5.simulate.simulator import Simulator
from gem5.utils.requires import requires
from gem5.components.cachehierarchies.classic.private_l1_shared_l2_cache_hierarchy import PrivateL1SharedL2CacheHierarchy


requires(isa_required=ISA.ARM)

repo_root = Path(__file__).resolve().parents[2]
binary = repo_root / "resources" / "binaries" / "no_acc" / "openblas_fp16_sve_gemm"
dimensions = [os.environ.get(name, default) for name, default in (
    ("M", "2"), ("N", "3"), ("K", "2")
)]

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
    arguments=dimensions,
)
Simulator(board=board).run()
