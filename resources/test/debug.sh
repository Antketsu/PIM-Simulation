#!/bin/bash

gem5_path="../../gem5-pim/build/ARM/gem5.debug"
#Create a out directory whose name is the current date and time
outdir=$(date +"%Y-%m-%d_%H-%M-%S")
config_file="../gem5_scripts/add_acc.py"
#Call gem5 with redirected output and the args from the command line
$gem5_path "--debug-flags=PIM" -d ./test_out/$outdir -r $config_file "$@"
#$gem5_path "--debug-flags=PIM,PIM_PIPELINE,LSQ_MINOR" -d ./test_out/$outdir -r $config_file "$@"
