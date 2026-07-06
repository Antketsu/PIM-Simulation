import os
import pandas as pd
import re

OUTPUT_CSV = 'resumen_gem5.csv'

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
                elif name in ['board.memory.mem_ctrl.readBursts', 
                              'board.pim.mem_ctrl.readBursts']:
                    data['total_mem_reads'] += int(val)
                
                # 4. Sumar Escrituras (Normal + PIM)
                elif name in ['board.memory.mem_ctrl.writeBursts',
                              'board.pim.mem_ctrl.writeBursts']:
                    data['total_mem_writes'] += int(val)
                elif name == 'board.processor.cores.core.lsq.totalMemInsts':
                    data['lsq_total_mem_insts'] = int(val)
                elif name == 'board.processor.cores.core.lsq.totalLsqCycles':
                    data['lsq_total_cycles'] = int(val)
                elif name == 'board.processor.cores.core.lsq.avgLsqCycles':
                    data['lsq_avg_cycles'] = float(val)

    # Calculamos la columna final de accesos a memoria
    data['mem_total_accesses'] = data['total_mem_reads'] + data['total_mem_writes']
    return data


def main():
    resultados = []
    base_path = "../test/test_out"
    
    if not os.path.exists(base_path):
        print(f"Error: La ruta base {base_path} no existe.")
        return

    # Expresión regular para capturar la estructura: kernel_modo_filasxcolumnas
    # Ejemplo: gemmv_no_acc_opt_1024x2048
    # Group 1: kernel (add, mul, gemmv)
    # Group 2: mode (acc, no_acc, no_acc_opt)
    # Group 3: rows / cols (cualquier par de números separados por 'x')
    pattern = re.compile(r"^(add|mul|gemv)_(acc|no_acc_opt)_(\d+x\d+)$")

    print(f"Escaneando carpetas en {base_path}...\n")
    
    # Listar todo el contenido del directorio de forma dinámica
    for item in sorted(os.listdir(base_path)):
        folder_path = os.path.join(base_path, item)
        
        # Asegurarnos de que es una carpeta y que cumple con el patrón de nombres
        if os.path.isdir(folder_path):
            match = pattern.match(item)
            if match:
                kernel = match.group(1)
                mode = match.group(2)
                dimension = match.group(3)
                
                print(f"Procesando [{kernel.upper()} - {mode}] Tamaño: {dimension} -> {item}")
                
                # Llamar a tu función parse_stats original
                res = parse_stats(folder_path)
                if res:
                    # Opcional: puedes inyectar las dimensiones parseadas al diccionario 
                    # si quieres graficar o filtrar por tamaño de matriz más adelante
                    res['kernel_type'] = kernel
                    res['execution_mode'] = mode
                    res['matrix_size'] = dimension
                    
                    resultados.append(res)

    if not resultados:
        print("\n¡Alerta! No se procesó ningún resultado válido.")
        return

    # Crear DataFrame y guardar
    df = pd.DataFrame(resultados)
    
    # Seleccionar y reordenar columnas finales (añadí las nuevas por si te sirven)
    cols = ['folder', 'kernel_type', 'execution_mode', 'matrix_size', 
            'sim_seconds', 'cache_accesses', 'mem_total_accesses', 
            'lsq_total_mem_insts', 'lsq_total_cycles', 'lsq_avg_cycles']
    
    # Filtrar solo por las columnas que realmente existan en el df para evitar KeyErrors
    cols_validas = [c for c in cols if c in df.columns]
    df = df[cols_validas]
    
    df.to_csv(OUTPUT_CSV, index=False)
    print(f"\n¡Listo! Archivo guardado como: {OUTPUT_CSV}")
    print(df)

if __name__ == "__main__":
    main()