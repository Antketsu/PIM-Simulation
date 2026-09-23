#!/usr/bin/env bash

set -euo pipefail

if [[ $# -lt 2 ]]; then
	echo "Usage: $0 <output_dir>  <kernel> [gem5 arguments...]" >&2
	exit 1
fi

gem5_exec="gem5-pim/build/ARM/gem5.opt"
output_dir="$1"
kernel="$2"
debug=1
gem5_script="${kernel}_acc.py"
shift 2

mkdir -p "$output_dir"
mkdir -p temp

DEBUG_FLAGS=""
if [[ $debug -eq 1 ]]; then
	DEBUG_FLAGS="--debug-flags=PIM,PIM_PIPELINE,LSQ_MINOR"
fi

"$gem5_exec" $DEBUG_FLAGS -d temp -r resources/gem5_scripts/"$gem5_script" "$@"

cp temp/stats.txt "$output_dir/stats.txt"
cp  temp/simout.txt "$output_dir/simout.txt"

grep "hist_ticks_between_instrs" "$output_dir/stats.txt" > "$output_dir/hist_ticks_between_instrs.txt"

python3 "resources/analisis/plot_hist_ticks_between_instrs.py" \
	"$output_dir/stats.txt"

rm -rf temp