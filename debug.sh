#!/bin/bash

gem5_path="/homelocal/antoma19_local/u/tfm/gem5-pim/build/ARM/gem5.opt"
#Create a out directory whose name is the current date and time
outdir=$(date +"%Y-%m-%d_%H-%M-%S")
config_file="gem5_scripts/run_pim_kernel_gem5.py"
#Call gem5 with redirected output and the args from the command line
$gem5_path "--debug-flags=PIM,PIMCtrl" -d ./test_out/$outdir -r $config_file "$@"
