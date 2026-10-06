# Running experiments

Experiment definitions live in TOML files in this directory. Each `[[runs]]`
block defines a mode and a gem5 config; `sizes` creates square cases, while
`cases` defines explicit dimensions. Workload parameters are supplied through
the run's `environment` table, with placeholders such as `{size}`, `{rows}`,
and `{cols}`.

Gem5 config parameters use uppercase environment names consistently:

| Workload | Environment variables |
| --- | --- |
| Add | `ROWS`, `COLS`, `PRINT_RESULT` |
| Matrix multiply | `ROWS_A`, `ROWS_B`, `COLS_B`, `PRINT_RESULT` |
| Convolution | `CONV_H`, `CONV_W`, `CONV_C`, `CONV_KH`, `CONV_KW`, `CONV_OC`, `CONV_PRINT` |
| OpenBLAS GEMM | `M`, `N`, `K` |

From the repository root:

```sh
make -C kernels/pim
make -C kernels/cpu
python3 sim/runner.py experiments/add.toml --run-id add-baseline
python3 sim/runner.py experiments/mul.toml --run-id mul-baseline --jobs 2
python3 sim/runner.py experiments/gemv.toml --run-id gemv-baseline
```

The PIM and CPU Makefiles place kernel executables in `kernels/build/`, with a
`_pim` or `_cpu` suffix in each filename so names cannot collide. The Makefiles
only build kernels; gem5 execution is driven by the experiment runner. They do
not emit assembly listings. The vendored OpenBLAS tree keeps its own library
build products beside its sources because its build expects them there.

The multiply experiment compares PIM against the OpenBLAS FP16/SVE GEMM
baseline. Its TOML entry supplies `M`, `N`, and `K` per case directly in the
gem5 config process environment. The convolution config similarly reads
`CONV_H`, `CONV_W`, `CONV_C`, `CONV_KH`, `CONV_KW`, and `CONV_OC` from the
environment; no Makefile target launches either simulation.

The runner expects `gem5-pim/build/ARM/gem5.opt` by default. Override it with
`--gem5 /path/to/gem5.opt`. Every invocation requires a unique `--run-id`, used
as the results folder itself. For example, `--run-id gemv` writes mode and case
folders directly under `results/gemv/`, such as `results/gemv/pim/128x128/` and
`results/gemv/openblas/128x128/`. There is no intermediate run or kernel-name
folder. The runner refuses to reuse an existing run-id; choose another name to
keep each experiment invocation separate. Each case includes a `run.json`
record of its command and status.

Summarize and plot a run (or a results tree containing multiple runs):

```sh
python3 analysis/extract_stats.py add_bigger_lsq mul_no_copy
python3 analysis/plot_stats.py results/summary.csv
```

Pass one or more exact run-id folder names to the extractor; it scans only
those folders and combines the groups you selected. The summary CSV
defaults to `results/summary.csv`. Plots are saved under the matching run-id
folder, such as `results/gemv/`; pass `--output-dir` to choose another parent
location for those run-id folders.

The older launchers in `tests/` remain available during migration and
still write to their historical output locations.
