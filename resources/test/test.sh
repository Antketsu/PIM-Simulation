#!/bin/bash

gem5_path="../../gem5-pim/build/X86/gem5.opt"
#Create a out directory whose name is the current date and time
outdir=$(date +"%Y-%m-%d_%H-%M-%S")
config_file="../gem5_scripts/matrix_multiplication_acc.py"
#Call gem5 with redirected output and the args from the command line
$gem5_path -d ./test_out/$outdir -r $config_file "$@"
