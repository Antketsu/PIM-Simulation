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
from gem5.components.processors.simple_processor import SimpleProcessor
from gem5.resources.resource import BinaryResource  
from gem5.components.memory.pim import PIMAccelerator

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--no_acc", action="store_true", help="indicate to execute the kernel without accelerator")
    parser.add_argument("--all_banks", action="store_true", help="indicate to execute the kernel that uses all banks")
    parser.add_argument("--opt", action="store_true", help="indicate to execute the optimized kernel")
    parser.add_argument("--kernel", help="kernel to execute")
    parser.add_argument("--rowsA", type=int, help="number of rows in matrix A")
    parser.add_argument("--rowsB", type=int, help="number of rows in matrix B")
    parser.add_argument("--colsA", type=int, help="number of columns in matrix A")
    parser.add_argument("--colsB", type=int, help="number of columns in matrix B")
    parser.add_argument("--rowsC", type=int, help="number of rows in matrix C")
    parser.add_argument("--colsC", type=int, help="number of columns in matrix C")
    args = parser.parse_args()
    return args

args = parse_args()
processing_units = 8 if args.all_banks else 1
ELEMS_PER_ROW = 512

elemsA = args.rowsA * args.colsA
elems_per_bank_A = elemsA // processing_units
rows_A = elems_per_bank_A // ELEMS_PER_ROW
rows_A = rows_A + 1 if elems_per_bank_A % ELEMS_PER_ROW != 0 else rows_A

elemsB = args.rowsB * args.colsB
elems_per_bank_B = elemsB // processing_units
rows_B = elems_per_bank_B // ELEMS_PER_ROW
rows_B = rows_B + 1 if elems_per_bank_B % ELEMS_PER_ROW != 0 else rows_B

elemsC = args.rowsC * args.colsC
elems_per_bank_C = elemsC // processing_units
rows_C = elems_per_bank_C // ELEMS_PER_ROW
rows_C = rows_C + 1 if elems_per_bank_C % ELEMS_PER_ROW != 0 else rows_C

def exit_handler_test():
    process = processor.get_cores()[0].core.workload[0]
    # VA, PA, Size, Cacheable
    process.map(0x10000000, 0xC4000000, 0x1000000, False) # PIM region
    print("Mapped memory region at VA 0x10000000 to PA 0xC4000000")

    process.map(0x20000000, 0xD0000000, 0xFFFFFFF, False)

    yield False
    yield True


def exit_handler():
    process = processor.get_cores()[0].core.workload[0]
    # VA, PA, Size, Cacheable
    process.map(0x10000000, 0xC4000000, 0x1000000, False) # PIM region
    print("Mapped memory region at VA 0x10000000 to PA 0xC4000000")

    row_size = 0x00001FFF 
    bank_increment = 0x00000800 #We add two bank indexes
    virtual_address = 0x20000000
    even_bank_physical_address = 0xD0000000
    virtual_increment = 0x00002000
    row_increment = 0x00040000
    # Operand A in bank 0
    for i in range(processing_units):
        print("Mapping A in bank {}".format(i))
        physical_address = even_bank_physical_address
        for j in range(rows_A):
             process.map(virtual_address, physical_address, row_size, False) 
             print("Mapped memory region at VA 0x{:x} to PA 0x{:x}".format(virtual_address, physical_address))
             virtual_address += virtual_increment
             physical_address += row_increment
        even_bank_physical_address += bank_increment

    odd_bank_physical_address = 0xD0000400
    # Operand B in bank 1
    for i in range(processing_units):
        print("Mapping B in bank {}".format(i))
        physical_address = odd_bank_physical_address
        for j in range(rows_B):
             process.map(virtual_address, physical_address, row_size, False) 
             print("Mapped memory region at VA 0x{:x} to PA 0x{:x}".format(virtual_address, physical_address))
             virtual_address += virtual_increment
             physical_address += row_increment
        odd_bank_physical_address += bank_increment
    # Operand C in bank 0
    even_bank_physical_address = 0xD0000000 + row_increment * rows_A * processing_units
    for i in range(processing_units):
        print("Mapping C in bank {}".format(i))
        physical_address = even_bank_physical_address
        for j in range(rows_C):
             process.map(virtual_address, physical_address, row_size, False) 
             print("Mapped memory region at VA 0x{:x} to PA 0x{:x}".format(virtual_address, physical_address))
             virtual_address += virtual_increment
             physical_address += row_increment
        even_bank_physical_address += bank_increment
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

processor = SimpleProcessor(num_cores=1,isa=ISA.ARM,cpu_type=CPUTypes.MINOR)

kernel_path = "/home/antonio/U/laburo/PIM-Simulation/resources/binaries/"

board = None

if args.no_acc:
    print("Running without accelerator")
    pim = None
    board = SimpleBoard(
        clk_freq="1GHz",
        processor=processor,
        memory=memory,
        cache_hierarchy=cache_hierarchy,
    )
    if args.opt:
        print("Running optimized kernel")
        kernel_path += "no_acc/exec_no_acc_kernel_opt"
    else:
        print("Running non-optimized kernel")
        kernel_path += "no_acc/exec_no_acc_kernel"
else:
    pim = PIMAccelerator(size="3GB")
    board = PIMBoard(
        clk_freq="1GHz",
        processor=processor,
        memory=memory,
        cache_hierarchy=cache_hierarchy,
        pim=pim,
    )
    if args.all_banks:
        print("Running kernel that uses all banks")
    else:
        print("Running kernel that uses only one bank")
    kernel_path += "exec_pim_kernel"

kernel_codes = {
    "add": 0,
    "mul": 1,
}

board.set_se_binary_workload(
    binary=BinaryResource(kernel_path),
    arguments=[str(args.rowsA),
                str(args.colsA),
                str(args.rowsB),
                str(args.colsB),
                str(args.rowsC),
                str(args.colsC),
                str(kernel_codes[args.kernel]),
                str(processing_units)],)

simulator = None

handler = exit_handler_test()

print(f"Running {kernel_path}")

if args.no_acc:
    simulator = Simulator(
        board=board,
    )
else:
    simulator = Simulator(
        board=board,
        on_exit_event= {
            ExitEvent.EXIT: handler,
        }
    )
    
simulator.run()