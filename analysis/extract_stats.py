import os
import pandas as pd
import re
import argparse
import json
from pathlib import Path

OUTPUT_CSV = 'results/summary.csv'

def parse_stats(folder_path):
    stats_file = os.path.join(folder_path, 'stats.txt')
    if not os.path.exists(stats_file):
        print(f"Error: No se encuentra {stats_file}")
        return None

    # Inicializamos contadores
    data = {
        'folder': os.path.basename(folder_path),
        'sim_seconds': 0.0,
        'l1d_cache_accesses': 0,
        'l1i_cache_accesses': 0,
        'l2_cache_accesses': 0,
        'total_mem_reads': 0,
        'total_mem_writes': 0,
        'pim_conf_accesses': 0,
        'mem_dram_read_hits': 0,
        'mem_dram_read_misses': 0,
        'mem_dram_write_hits': 0,
        'mem_dram_write_misses': 0,
        'pim_dram_read_hits': 0,
        'pim_dram_read_misses': 0,
        'pim_dram_write_hits': 0,
        'pim_dram_write_misses': 0,
        'perfect_gaps': 0,
        'total_gaps_between_instrs': 0,
    }
    
    with open(stats_file, 'r') as f:
        found_block = False
        for line in f:
            # Detectar inicio del primer bloque
            if "Begin Simulation Statistics" in line:
                found_block = True
                continue
            
            # Al encontrar el primer "End", dejamos de leer el archivo por completo
            if "End Simulation Statistics" in line and found_block:
                break
            
            if found_block:
                parts = line.split()
                if len(parts) < 2: continue
                
                name = parts[0]
                try:
                    val = float(parts[1])
                except ValueError:
                    continue

                if name == 'simSeconds':
                    data['sim_seconds'] = val * 1000 #ms

                elif name == 'board.cache_hierarchy.l1dcaches.overallAccesses::total':
                    data['l1d_cache_accesses'] = int(val)
                elif name == 'board.cache_hierarchy.l1icaches.overallAccesses::total':
                    data['l1i_cache_accesses'] = int(val)
                elif name == 'board.cache_hierarchy.l2cache.overallAccesses::total':
                    data['l2_cache_accesses'] = int(val)

                elif name in ['board.memory.mem_ctrl.readBursts',
                              'board.pim.mem_ctrl.readBursts']:
                    data['total_mem_reads'] += int(val)
                elif name in ['board.memory.mem_ctrl.writeBursts',
                              'board.pim.mem_ctrl.writeBursts']:
                    data['total_mem_writes'] += int(val)

                elif name == 'board.pim.mem_ctrl.dram.pim_conf_accesses':
                    data['pim_conf_accesses'] = int(val)

                elif name == 'board.memory.mem_ctrl.dram.read_hits':
                    data['mem_dram_read_hits'] = int(val)
                elif name == 'board.memory.mem_ctrl.dram.read_misses':
                    data['mem_dram_read_misses'] = int(val)
                elif name == 'board.memory.mem_ctrl.dram.write_hits':
                    data['mem_dram_write_hits'] = int(val)
                elif name == 'board.memory.mem_ctrl.dram.write_misses':
                    data['mem_dram_write_misses'] = int(val)

                elif name == 'board.pim.mem_ctrl.dram.read_hits':
                    data['pim_dram_read_hits'] = int(val)
                elif name == 'board.pim.mem_ctrl.dram.read_misses':
                    data['pim_dram_read_misses'] = int(val)
                elif name == 'board.pim.mem_ctrl.dram.write_hits':
                    data['pim_dram_write_hits'] = int(val)
                elif name == 'board.pim.mem_ctrl.dram.write_misses':
                    data['pim_dram_write_misses'] = int(val)

                elif name == 'board.pim.mem_ctrl.dram.perfect_gaps':
                    data['perfect_gaps'] = int(val)
                elif name == 'board.pim.mem_ctrl.dram.total_gaps_between_instrs':
                    data['total_gaps_between_instrs'] = int(val)

                elif name == 'board.processor.cores.core.lsq.totalMemInsts':
                    data['lsq_total_mem_insts'] = int(val)
                elif name == 'board.processor.cores.core.lsq.totalLsqCycles':
                    data['lsq_total_cycles'] = int(val)
                elif name == 'board.processor.cores.core.lsq.avgLsqCycles':
                    data['lsq_avg_cycles'] = float(val)

    # Calculamos la columna final de accesos a memoria
    data['mem_total_accesses'] = data['total_mem_reads'] + data['total_mem_writes'] - data['pim_conf_accesses']
    total_gaps = data['total_gaps_between_instrs']
    data['perfect_gaps_pct'] = (
        data['perfect_gaps'] / total_gaps * 100 if total_gaps else None
    )
    return data


def main():
    parser = argparse.ArgumentParser(description="Collect gem5 stats into a CSV.")
    parser.add_argument("result_groups", nargs="+", help="named result folders under --results-root")
    parser.add_argument("--results-root", default="results", help="root containing result groups")
    parser.add_argument("--output", default=OUTPUT_CSV, help="output CSV file path")
    args = parser.parse_args()

    resultados = []
    results_root = Path(args.results_root).resolve()
    selected_groups = []
    for group in args.result_groups:
        if Path(group).name != group or group in {".", ".."}:
            parser.error(f"result group must be a folder name: {group}")
        group_path = results_root / group
        if not group_path.is_dir():
            parser.error(f"result group does not exist: {group_path}")
        selected_groups.append(group_path)

    # Expresión regular para capturar la estructura: kernel_modo_filasxcolumnas
    # Ejemplo: gemmv_no_acc_opt_1024x2048
    # Group 1: kernel (add, mul, gemmv)
    # Group 2: mode (acc, no_acc, no_acc_opt)
    # Group 3: rows / cols (cualquier par de números separados por 'x')
    pattern = re.compile(r"^(add|mul|gemv)_(acc|no_acc_opt)_(\d+x\d+)$")

    print(f"Scanning selected result groups under {results_root}...\n")
    for group_path in selected_groups:
        for stats_file in sorted(group_path.rglob("stats.txt")):
            folder_path = stats_file.parent
            run_file = folder_path / "run.json"
            try:
                metadata = json.loads(run_file.read_text()) if run_file.is_file() else {}
            except (OSError, json.JSONDecodeError) as exc:
                print(f"Skipping invalid metadata {run_file}: {exc}")
                metadata = {}
            item = folder_path.name
            match = pattern.match(item)
            res = parse_stats(str(folder_path))
            if not res:
                continue
            if metadata:
                res["kernel_type"] = metadata.get("name", "unknown")
                res["execution_mode"] = metadata.get("mode", "unknown")
                res["matrix_size"] = metadata.get("case", item)
            elif match:
                res["kernel_type"] = match.group(1)
                res["execution_mode"] = match.group(2)
                res["matrix_size"] = match.group(3)
            else:
                continue
            res["folder"] = str(folder_path.relative_to(results_root))
            resultados.append(res)

    if not resultados:
        print("\n¡Alerta! No se procesó ningún resultado válido.")
        return

    # Crear DataFrame y guardar
    df = pd.DataFrame(resultados)
    
    # Seleccionar y reordenar columnas finales (añadí las nuevas por si te sirven)
    cols = ['folder', 'kernel_type', 'execution_mode', 'matrix_size',
            'sim_seconds', 'l1d_cache_accesses', 'l1i_cache_accesses', 'l2_cache_accesses',
            'mem_total_accesses', 'pim_conf_accesses',
            'mem_dram_read_hits', 'mem_dram_read_misses',
            'mem_dram_write_hits', 'mem_dram_write_misses',
            'pim_dram_read_hits', 'pim_dram_read_misses',
            'pim_dram_write_hits', 'pim_dram_write_misses',
            'perfect_gaps_pct',
            'lsq_total_mem_insts', 'lsq_total_cycles', 'lsq_avg_cycles']
    
    # Filtrar solo por las columnas que realmente existan en el df para evitar KeyErrors
    cols_validas = [c for c in cols if c in df.columns]
    df = df[cols_validas]
    
    output_csv = Path(args.output).resolve()
    output_csv.parent.mkdir(parents=True, exist_ok=True)
    df.to_csv(output_csv, index=False)
    print(f"\nCSV saved as: {output_csv}")
    print(df)

if __name__ == "__main__":
    main()
