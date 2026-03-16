from gem5.components.boards.x86_board import X86Board
from gem5.components.cachehierarchies.classic.private_l1_shared_l2_cache_hierarchy import PrivateL1SharedL2CacheHierarchy
from gem5.components.memory.hbm import HBM2Stack
from gem5.components.processors.cpu_types import CPUTypes
from gem5.components.processors.simple_processor import SimpleProcessor
from gem5.isas import ISA
from gem5.resources.resource import obtain_resource
from gem5.simulate.simulator import Simulator


cache_hierarchy = PrivateL1SharedL2CacheHierarchy(
    l1d_size="16kB",
    l1d_assoc=8,
    l1i_size="16kB",
    l1i_assoc=8,
    l2_size="256kB",
    l2_assoc=16,
)



# Setup the system memory.
memory = HBM2Stack(size="3GB")

processor = SimpleProcessor(num_cores=1,isa=ISA.X86,cpu_type=CPUTypes.TIMING)

board = X86Board(
    clk_freq="1GHz",
    processor=processor,
    memory=memory,
    cache_hierarchy=cache_hierarchy,
)

#Set worload to hello world of gem5 resources
board.set_se_binary_workload(obtain_resource(resource_id="x86-hello64-static"))

simulator = Simulator(board=board,)

simulator.run()
