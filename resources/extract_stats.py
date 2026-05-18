import os
import pandas as pd
import re

OUTPUT_CSV = 'resumen_gem5_2.csv'

def parse_stats(folder_path):
    stats_file = os.path.join(folder_path, 'stats.txt')
    if not os.path.exists(stats_file):
        print(f"Error: No se encuentra {stats_file}")
        return None

    # Inicializamos contadores
    data = {
        'folder': os.path.basename(folder_path),
        'sim_seconds': 0.0,
        'cache_accesses': 0,
        'total_mem_reads': 0,
        'total_mem_writes': 0
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

                # 1. Segundos de simulación
                if name == 'simSeconds':
                    data['sim_seconds'] = val
                
                # 2. Accesos a Cache L1D total
                elif name == 'board.cache_hierarchy.l1dcaches.overallAccesses::total':
                    data['cache_accesses'] = int(val)
                
                # 3. Sumar Lecturas (Normal + PIM)
                elif name in ['board.memory.mem_ctrl.dram.readBursts', 
                              'board.pim.mem_ctrl.dram.readBursts']:
                    data['total_mem_reads'] += int(val)
                
                # 4. Sumar Escrituras (Normal + PIM)
                elif name in ['board.memory.mem_ctrl.dram.writeBursts', 
                              'board.pim.mem_ctrl.dram.writeBursts']:
                    data['total_mem_writes'] += int(val)

    # Calculamos la columna final de accesos a memoria
    data['mem_total_accesses'] = data['total_mem_reads'] + data['total_mem_writes']
    return data


def main():
    resultados = []
    kernels = ['add', 'mul']
    modes = ['no_acc', 'no_acc_opt', 'all_cores']
    sizes = [128, 256, 512, 1024]
    for kernel in kernels:
        for mode in modes:
            for size in sizes:
                folder_name = f"{kernel}_{mode}_{size}x{size}"
                folder_path = os.path.join("test_out", folder_name)
                print(f"Procesando {folder_path}...")
                res = parse_stats(folder_path)
                if res:
                    resultados.append(res)
    # Crear DataFrame y guardar
    df = pd.DataFrame(resultados)
    # Seleccionar y reordenar columnas finales
    cols = ['folder', 'sim_seconds', 'cache_accesses', 'mem_total_accesses']
    df = df[cols]
    
    df.to_csv(OUTPUT_CSV, index=False)
    print(f"\n¡Listo! Archivo guardado como: {OUTPUT_CSV}")
    print(df)

if __name__ == "__main__":
    main()