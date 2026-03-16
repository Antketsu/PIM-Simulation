#!/bin/bash

gem5_path="/homelocal/antoma19_local/u/tfm/gem5-pim/build/X86/gem5.opt"
#Create a out directory whose name is the current date and time
outdir=$(date +"%Y-%m-%d_%H-%M-%S")
config_file="try_kernel.py"
#Call gem5 with redirected output and the args from the command line
$gem5_path "--debug-flags=PIM" -d ./test_out/$outdir -r $config_file "$@"
