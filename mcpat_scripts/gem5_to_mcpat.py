import argparse
import json
import re
import xml.etree.ElementTree as ET
from xml.dom import minidom

def parse_stats(stats_file):
    stats = {}
    try:
        with open(stats_file, 'r') as f:
            for line in f:
                if not line.strip() or line.startswith('-'):
                    continue
                parts = re.split(r'\s+', line.strip())
                if len(parts) >= 2:
                    try:
                        stats[parts[0]] = float(parts[1])
                    except ValueError:
                        continue
    except FileNotFoundError:
        print(f"Error: Stats file '{stats_file}' not found.")
    return stats

def parse_config(config_file):
    try:
        with open(config_file, 'r') as f:
            return json.load(f)
    except FileNotFoundError:
        print(f"Error: Config file '{config_file}' not found.")
        return {}

def generate_xml(config_path, stats_path, template_path, output_path):
    # Now correctly parsing inside the function using the paths
    config = parse_config(config_path)
    stats = parse_stats(stats_path)
    
    if not config or not stats:
        return

    tree = ET.parse(template_path)
    root = tree.getroot()

    def set_val(path, name, value, is_stat=False):
        tag = "stat" if is_stat else "param"
        for comp in root.iter('component'):
            if comp.get('id') == path or comp.get('name') == path:
                for item in comp.findall(tag):
                    if item.get('name') == name:
                        if isinstance(value, (int, float)):
                            item.set('value', str(int(value)))
                        else:
                            item.set('value', str(value))
                        return

    # --- Extract metadata from config.json ---
    try:
        # Based on your config.json: Root -> board -> cache_hierarchy
        board = config['board']
        l1i_size = board['cache_hierarchy']['l1icaches'][0]['size']
        l1d_size = board['cache_hierarchy']['l1dcaches'][0]['size']
        l2_size = board['cache_hierarchy']['l2cache']['size']
    except (KeyError, IndexError):
        print("Warning: Could not auto-detect cache sizes, using defaults.")
        l1i_size, l1d_size, l2_size = 16384, 16384, 262144

    # --- System Level Mapping ---
    clock_mhz = 1000 
    total_cycles = stats.get('board.processor.cores.core.numCycles', 0)
    
    set_val('system', 'number_of_cores', 1)
    set_val('system', 'number_of_L2s', 1)
    set_val('system', 'target_core_clockrate', clock_mhz)
    set_val('system', 'total_cycles', total_cycles, True)

    # --- Core 0 Mapping ---
    set_val('system.core0', 'clock_rate', clock_mhz)
    set_val('system.core0', 'total_instructions', stats.get('simInsts', 0), True)
    set_val('system.core0', 'int_instructions', stats.get('board.processor.cores.core.commitStats0.numIntInsts', 0), True)
    set_val('system.core0', 'fp_instructions', stats.get('board.processor.cores.core.commitStats0.numFpInsts', 0), True)
    set_val('system.core0', 'branch_instructions', stats.get('board.processor.cores.core.executeStats0.numBranches', 0), True)
    set_val('system.core0', 'load_instructions', stats.get('board.processor.cores.core.commitStats0.numLoadInsts', 0), True)
    set_val('system.core0', 'store_instructions', stats.get('board.processor.cores.core.commitStats0.numStoreInsts', 0), True)
    set_val('system.core0', 'total_cycles', total_cycles, True)
    set_val('system.core0', 'busy_cycles', total_cycles, True)

    # --- Caches ---
    set_val('system.core0.icache', 'icache_config', f"{l1i_size},64,8,1,1,1,64,0")
    set_val('system.core0.icache', 'read_accesses', stats.get('board.cache_hierarchy.l1icaches.overallAccesses::total', 0), True)
    set_val('system.core0.icache', 'read_misses', stats.get('board.cache_hierarchy.l1icaches.overallMisses::total', 0), True)

    set_val('system.core0.dcache', 'dcache_config', f"{l1d_size},64,8,1,1,1,64,1")
    set_val('system.core0.dcache', 'read_accesses', stats.get('board.cache_hierarchy.l1dcaches.ReadReq.accesses::total', 0), True)
    set_val('system.core0.dcache', 'write_accesses', stats.get('board.cache_hierarchy.l1dcaches.WriteReq.accesses::total', 0), True)
    set_val('system.core0.dcache', 'read_misses', stats.get('board.cache_hierarchy.l1dcaches.ReadReq.misses::total', 0), True)
    set_val('system.core0.dcache', 'write_misses', stats.get('board.cache_hierarchy.l1dcaches.WriteReq.misses::total', 0), True)

    set_val('system.L20', 'L2_config', f"{l2_size},64,16,1,1,10,64,1")
    set_val('system.L20', 'read_accesses', stats.get('board.cache_hierarchy.l2cache.overallAccesses::total', 0), True)
    set_val('system.L20', 'read_misses', stats.get('board.cache_hierarchy.l2cache.overallMisses::total', 0), True)

    # --- Memory ---
    mem_reads = stats.get('board.memory.mem_ctrl.readReqs', 0) + stats.get('board.pim.mem_ctrl.readReqs', 0) + stats.get('board.pim.mem_ctrl.PIMReads', 0)
    mem_writes = stats.get('board.memory.mem_ctrl.writeReqs', 0) + stats.get('board.pim.mem_ctrl.writeReqs', 0) + stats.get('board.pim.mem_ctrl.PIMWrites', 0)
    set_val('system.mc', 'memory_accesses', mem_reads + mem_writes, True)
    set_val('system.mc', 'memory_reads', mem_reads, True)
    set_val('system.mc', 'memory_writes', mem_writes, True)

    # --- NoC ---
    set_val('system.noc', 'total_accesses', mem_reads * 2 + mem_writes, True)

    # Save output
    xml_string = ET.tostring(root, encoding='utf-8')
    pretty_xml = minidom.parseString(xml_string).toprettyxml(indent="  ")
    with open(output_path, "w") as f:
        f.write(pretty_xml)
    print(f"Generated {output_path} successfully.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Convert gem5 stats to McPAT XML")
    parser.add_argument("-c", "--config", type=str, default="config.json")
    parser.add_argument("-s", "--stats", type=str, default="stats.txt")
    parser.add_argument("-t", "--template", type=str, default="ARM_A9_2GHz.xml")
    parser.add_argument("-o", "--output", type=str, default="mcpat_input.xml")
    args = parser.parse_args()
    
    # PASS THE FILENAMES DIRECTLY
    generate_xml(args.config, args.stats, args.template, args.output)