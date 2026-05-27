#!/bin/python3
import subprocess
import threading

gem5_path="../../gem5-pim/build/ARM/gem5.opt"
config_file="../gem5_scripts/mul_no_acc.py"

def run_simulation(lenv, cols):
    print(f"Running simulation for vector {lenv} and matrix {lenv}x{cols}...")
    outdir=f"gemmv_no_acc_opt_{lenv}x{cols}"
    script_args = f"--rowsA {1} --rowsB {lenv} --colsB {cols} --opt"
    command = f"{gem5_path} -d ./test_out/{outdir} -r {config_file} {script_args}"
    subprocess.run(command, shell=True, executable="/bin/bash")
    print(f"Simulation for size {lenv}x{cols} completed!")

# Loop over matrix sizes and create threads
threads = []
for lenv, cols in [(128, 128), (512, 512), (1024, 2048), (2048, 4096), (4096, 8192)]:
    thread = threading.Thread(target=run_simulation, args=(lenv, cols))
    threads.append(thread)
    thread.start()

# Esperar a que terminen todos los hilos
for thread in threads:
    thread.join()

print("All simulations completed!")