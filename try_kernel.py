import argparse


from gem5.components.boards.x86_board import X86Board
from gem5.components.cachehierarchies.classic.private_l1_shared_l2_cache_hierarchy import (
    PrivateL1SharedL2CacheHierarchy
)
from gem5.components.cachehierarchies.classic.no_cache import NoCache
from gem5.components.memory.single_channel import SingleChannelDDR4_2400
from gem5.components.processors.cpu_types import CPUTypes
from gem5.isas import ISA
from gem5.resources.resource import obtain_resource
from gem5.simulate.simulator import Simulator
from gem5.resources.resource import Resource, DiskImageResource
from gem5.simulate.exit_event import ExitEvent
from pim_board import PIMBoard
from gem5.components.processors.simple_processor import SimpleProcessor
from gem5.resources.resource import BinaryResource  
from pim import PIMAccelerator

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--no_acc", action="store_true", help="indicate to execute the kernel without accelerator")
    parser.add_argument("--all_banks", action="store_true", help="indicate to execute the kernel that uses all banks")
    parser.add_argument("--kernel", help="kernel to execute")
    parser.add_argument("--rows", type=int, help="number of rows in the matrices")
    parser.add_argument("--cols", type=int, help="number of columns in the matrices")
    args = parser.parse_args()
    return args

args = parse_args()
elems = args.rows * args.cols
processing_units = 8 if args.all_banks else 1
ELEMS_PER_ROW = 4096
elems_per_bank = elems // processing_units
rows = elems_per_bank // ELEMS_PER_ROW
rows = rows + 1 if elems_per_bank % ELEMS_PER_ROW != 0 else rows


def exit_handler_old():
    print("Exit event triggered - mapping memory region in the simulated process")
    process = processor.get_cores()[0].core.workload[0]
    # VA, PA, Size, Cacheable
    process.map(0x10000000, 0xC4000000, 0x1000000, False) # PIM region
    print("Mapped memory region at VA 0x10000000 to PA 0xC4000000")
    yield False
    process.map(0x20000000, 0xD0000000, 0x1000000, False) # Operand A in bank0
    print("Mapped memory region at VA 0x20000000 to PA 0xD0000000")
    yield False
    process.map(0x30000000, 0xD1002000, 0x1000000, False) # Operand B in bank 1
    print("Mapped memory region at VA 0x30000000 to PA 0xD1000000")
    yield False
    process.map(0x40000000, 0xD2000000, 0x1000000, False) # Operand C in bank 0
    print("Mapped memory region at VA 0x40000000 to PA 0xD2000000")
    yield False
    yield True

def exit_handler_all_banks():
    bank_increment = 0x00004000 #We add two bank indexes, it's 4 and not 2 because banks bits take the last bit of the previous digit and the first 3 of the next -> 0000 0100
    print("Exit event triggered - mapping memory region in the simulated process")
    process = processor.get_cores()[0].core.workload[0]
    # VA, PA, Size, Cacheable
    process.map(0x10000000, 0xC4000000, 0x1000000, False) # PIM region
    print("Mapped memory region at VA 0x10000000 to PA 0xC4000000")
    yield False
    region_size = 0x00010000
    virtual_address = 0x20000000
    physical_address = 0xD0000000
    for i in range(8):
        process.map(virtual_address, physical_address, region_size, False) # Operand A in bank 0
        print("Mapped memory region at VA 0x{:x} to PA 0x{:x}".format(virtual_address, physical_address))
        virtual_address += region_size
        physical_address += bank_increment
        yield False
    virtual_address = 0x30000000
    physical_address = 0xD0002000
    for i in range(8):
        process.map(virtual_address, physical_address, region_size, False) # Operand B in bank 1
        print("Mapped memory region at VA 0x{:x} to PA 0x{:x}".format(virtual_address, physical_address))
        virtual_address += region_size
        physical_address += bank_increment
        yield False
    virtual_address = 0x40000000
    physical_address = 0xD2000000
    for i in range(8):
        process.map(virtual_address, physical_address, region_size, False) # Operand C in bank 0
        print("Mapped memory region at VA 0x{:x} to PA 0x{:x}".format(virtual_address, physical_address))
        virtual_address += region_size
        physical_address += bank_increment
        yield False
    yield True

def exit_handler():
    process = processor.get_cores()[0].core.workload[0]
    # VA, PA, Size, Cacheable
    process.map(0x10000000, 0xC4000000, 0x1000000, False) # PIM region
    print("Mapped memory region at VA 0x10000000 to PA 0xC4000000")

    row_size = 0x00001FFF 
    bank_increment = 0x00004000 #We add two bank indexes, it's 4 and not 2 because banks bits take the last bit of the previous digit and the first 3 of the next -> 0000 0100
    virtual_address = 0x20000000
    even_bank_physical_address = 0xD0000000
    virtual_increment = 0x00002000
    row_increment = 0x00040000
    # Operand A in bank 0
    for i in range(processing_units):
        physical_address = even_bank_physical_address
        for j in range(rows):
             process.map(virtual_address, physical_address, row_size, False) 
             print("Mapped memory region at VA 0x{:x} to PA 0x{:x}".format(virtual_address, physical_address))
             virtual_address += virtual_increment
             physical_address += row_increment
        even_bank_physical_address += bank_increment

    odd_bank_physical_address = 0xD0002000
    # Operand B in bank 1
    for i in range(processing_units):
        physical_address = odd_bank_physical_address
        for j in range(rows):
             process.map(virtual_address, physical_address, row_size, False) 
             print("Mapped memory region at VA 0x{:x} to PA 0x{:x}".format(virtual_address, physical_address))
             virtual_address += virtual_increment
             physical_address += row_increment
        odd_bank_physical_address += bank_increment
    # Operand C in bank 0
    even_bank_physical_address = 0xD0000000 + row_increment * rows
    for i in range(processing_units):
        physical_address = even_bank_physical_address
        for j in range(rows):
             process.map(virtual_address, physical_address, row_size, False) 
             print("Mapped memory region at VA 0x{:x} to PA 0x{:x}".format(virtual_address, physical_address))
             virtual_address += virtual_increment
             physical_address += row_increment
        even_bank_physical_address += bank_increment
    yield False
    yield True


cache_hierarchy = PrivateL1SharedL2CacheHierarchy(
    l1d_size="16kB",
    l1d_assoc=8,
    l1i_size="16kB",
    l1i_assoc=8,
    l2_size="256kB",
    l2_assoc=16,
)

# Setup the system memory.
memory = SingleChannelDDR4_2400(size="3GB")

processor = SimpleProcessor(num_cores=1,isa=ISA.X86,cpu_type=CPUTypes.ATOMIC)

kernels_path = "/homelocal/antoma19_local/u/tfm/pim-resources/binaries/"

board = None

if args.no_acc:
    print("Running without accelerator")
    pim = None
    board = X86Board(
        clk_freq="1GHz",
        processor=processor,
        memory=memory,
        cache_hierarchy=cache_hierarchy,
    )
    kernels_path += "no_acc/"
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
        kernels_path += "all_banks/"
    else:
        print("Running kernel that uses only one bank")
        kernels_path += "single_bank/"


board.set_se_binary_workload(
    binary=BinaryResource(kernels_path + args.kernel),
    arguments=[str(args.rows), str(args.cols)],)

simulator = None

handler = exit_handler_all_banks() if args.all_banks else exit_handler()

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