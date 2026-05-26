#!/bin/python3
import subprocess
import threading

gem5_path="../gem5-pim/build/ARM/gem5.opt"
config_file="gem5_scripts/run_pim_kernel_gem5.py"

def run_simulation(size):
    print(f"Running simulation for size {size}x{size}...")
    outdir=f"mul_no_acc_opt_{size}x{size}"
    script_args = f"--kernel mul --rowsA {size} --colsA {size} --rowsB {size} --colsB {size} --rowsC {size} --colsC {size} --no_acc --opt"
    command = f"{gem5_path} -d ./test_out/{outdir} -r {config_file} {script_args}"
    subprocess.run(command, shell=True, executable="/bin/bash")
    print(f"Simulation for size {size}x{size} completed!")

# Loop over matrix sizes and create threads
threads = []
for size in [128, 256, 512, 1024]:
    thread = threading.Thread(target=run_simulation, args=(size,))
    threads.append(thread)
    thread.start()

# Esperar a que terminen todos los hilos
for thread in threads:
    thread.join()

print("All simulations completed!")