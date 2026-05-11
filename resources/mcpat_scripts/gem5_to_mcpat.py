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
                # Eliminar comentarios de gem5 (# ...) para limpiar el valor
                line = re.sub(r'#.*', '', line)
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
                        # Convertimos a int para McPAT si es posible
                        val_str = str(int(value)) if isinstance(value, (int, float)) else str(value)
                        item.set('value', val_str)
                        return

    # --- Metadata de Config ---
    try:
        board = config['board']
        l1i_size = board['cache_hierarchy']['l1icaches'][0]['size']
        l1d_size = board['cache_hierarchy']['l1dcaches'][0]['size']
        l2_size = board['cache_hierarchy']['l2cache']['size']
    except (KeyError, IndexError):
        l1i_size, l1d_size, l2_size = 16384, 16384, 262144

    # --- System Level ---
    cpu_clock_mhz = 2000 
    total_cycles = stats.get('board.processor.cores.core.numCycles', 0)
    
    set_val('system', 'number_of_cores', 1)
    set_val('system', 'target_core_clockrate', cpu_clock_mhz)
    set_val('system', 'total_cycles', total_cycles, True)

    # --- Core 0 ---
    set_val('system.core0', 'clock_rate', cpu_clock_mhz)
    set_val('system.core0', 'total_instructions', stats.get('simInsts', 0), True)

    # --- Caches ---
    set_val('system.core0.icache', 'icache_config', f"{l1i_size},64,8,1,1,1,64,0")
    set_val('system.core0.dcache', 'dcache_config', f"{l1d_size},64,8,1,1,1,64,1")
    set_val('system.L20', 'L2_config', f"{l2_size},64,16,1,1,10,64,1")

    # --- Memory Controller (Normal) ---
    mem_reads = stats.get('board.memory.mem_ctrl.readReqs', 0)
    mem_writes = stats.get('board.memory.mem_ctrl.writeReqs', 0)
    set_val('system.mc', 'memory_accesses', mem_reads + mem_writes, True)
    set_val('system.mc', 'memory_reads', mem_reads, True)
    set_val('system.mc', 'memory_writes', mem_writes, True)

    # --- PIM ACCELERATOR MAPPING ---
    pim_id = 'system.pim'
    # Frecuencia del PIM (ajustar si gem5 usa otra)
    set_val(pim_id, 'clockRate', 300) 
    
    # Ciclos totales del PIM (si no existe pim.numCycles, usamos el total del sistema)
    pim_cycles = stats.get('board.pim.mem_ctrl.dram.numCycles', total_cycles)
    set_val(pim_id, 'total_cycles', pim_cycles, True)

    pim_units = 8 if stats.get('board.pim.mem_ctrl.dram.all_bank_mode_switches', 0) > 0 else 1
    set_val(pim_id, 'number_units', pim_units)

    # Estadísticas de ejecución de instrucciones
    set_val(pim_id, 'fpu_accesses', stats.get('board.pim.mem_ctrl.dram.alu_instrs_executed', 0), True)
    
    # Estadísticas de Registros (GRF)
    set_val(pim_id, 'grf_reads', stats.get('board.pim.mem_ctrl.dram.grf_reads', 0), True)
    set_val(pim_id, 'grf_writes', stats.get('board.pim.mem_ctrl.dram.grf_writes', 0), True)
    
    # Estadísticas de Instrucciones (CRF)
    set_val(pim_id, 'crf_reads', stats.get('board.pim.mem_ctrl.dram.crf_reads', 0), True)
    set_val(pim_id, 'crf_writes', stats.get('board.pim.mem_ctrl.dram.crf_writes', 0), True)
    
    # Estadísticas de Escalares (SRF)
    set_val(pim_id, 'srf_reads', stats.get('board.pim.mem_ctrl.dram.srf_reads', 0), True)
    set_val(pim_id, 'srf_writes', stats.get('board.pim.mem_ctrl.dram.srf_writes', 0), True)

    # --- NoC ---
    set_val('system.noc', 'total_accesses', mem_reads * 2 + mem_writes, True)

    # Guardar XML
    xml_string = ET.tostring(root, encoding='utf-8')
    pretty_xml = minidom.parseString(xml_string).toprettyxml(indent="  ")
    with open(output_path, "w") as f:
        f.write(pretty_xml)
    print(f"Generated {output_path} with PIM stats successfully.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Convert gem5 stats to McPAT XML")
    parser.add_argument("-c", "--config", type=str, default="config.json")
    parser.add_argument("-s", "--stats", type=str, default="stats.txt")
    parser.add_argument("-t", "--template", type=str, default="template.xml")
    parser.add_argument("-o", "--output", type=str, default="mcpat_input.xml")
    args = parser.parse_args()
    
    generate_xml(args.config, args.stats, args.template, args.output)