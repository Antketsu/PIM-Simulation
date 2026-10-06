#!/usr/bin/env python3
"""Run a list of gem5 experiments described by a TOML file."""

from __future__ import annotations

import argparse
import concurrent.futures
import datetime as dt
import json
import os
from pathlib import Path
import subprocess
import sys
import tomllib


ROOT = Path(__file__).resolve().parents[1]


def load_jobs(manifest: Path) -> tuple[str, list[dict]]:
    with manifest.open("rb") as stream:
        data = tomllib.load(stream)

    experiment = data.get("experiment", {})
    name = experiment.get("name")
    if not name:
        raise ValueError("Manifest must define [experiment].name")

    jobs = []
    for run in data.get("runs", []):
        config = run.get("gem5_config", experiment.get("gem5_config"))
        if not config:
            raise ValueError(f"Run {run.get('mode', '<unnamed>')} has no gem5_config")
        cases = run.get("cases")
        if cases is None:
            cases = [[size, size] for size in run.get("sizes", [])]
        if not cases:
            raise ValueError(f"Run {run.get('mode', '<unnamed>')} needs sizes or cases")
        for case in cases:
            if isinstance(case, dict):
                values = {key: value for key, value in case.items() if key != "name"}
                label = str(case.get("name", "_".join(str(value) for value in values.values())))
            else:
                values = {"size": case[0], "rows": case[0], "cols": case[-1]}
                label = "x".join(str(value) for value in case)
            try:
                environment = {
                    key: str(value).format(**values)
                    for key, value in run.get("environment", {}).items()
                }
            except (KeyError, IndexError) as exc:
                raise ValueError(f"Invalid environment template in {run.get('mode')}: {exc}") from exc
            jobs.append({
                "name": name,
                "mode": run.get("mode", "default"),
                "case": label,
                "config": config,
                "environment": environment,
            })
    if not jobs:
        raise ValueError("Manifest contains no runs")
    return name, jobs


def reserve_run_dir(output_root: Path, run_id: str) -> Path:
    if Path(run_id).name != run_id or run_id in {".", ".."}:
        raise ValueError("--run-id must be a single folder name")
    output_root.mkdir(parents=True, exist_ok=True)
    run_dir = output_root / run_id
    run_dir.mkdir(parents=True, exist_ok=False)
    return run_dir


def execute(job: dict, gem5: Path, run_dir: Path) -> int:
    outdir = run_dir / job["mode"] / job["case"]
    if outdir.exists() and any(outdir.iterdir()):
        raise FileExistsError(f"Output already exists: {outdir} (choose a new --run-id)")
    outdir.mkdir(parents=True, exist_ok=True)

    config = (ROOT / job["config"]).resolve()
    if not config.is_file():
        raise FileNotFoundError(f"gem5 config not found: {config}")
    command = [str(gem5), "-d", str(outdir), "-r", str(config)]
    metadata = {
        **job,
        "result_group": run_dir.name,
        "run_id": run_dir.name,
        "command": command,
        "environment": job["environment"],
        "cwd": str(ROOT),
        "started_at": dt.datetime.now(dt.timezone.utc).isoformat(),
    }
    (outdir / "run.json").write_text(json.dumps(metadata, indent=2) + "\n")
    print("RUN", " ".join(command), flush=True)
    environment = os.environ.copy()
    environment.update(job["environment"])
    completed = subprocess.run(command, cwd=ROOT, env=environment, check=False)
    metadata["return_code"] = completed.returncode
    metadata["finished_at"] = dt.datetime.now(dt.timezone.utc).isoformat()
    (outdir / "run.json").write_text(json.dumps(metadata, indent=2) + "\n")
    return completed.returncode


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("manifest", type=Path, help="experiment TOML file")
    parser.add_argument("--gem5", type=Path, default=Path("gem5-pim/build/ARM/gem5.opt"))
    parser.add_argument("--output", type=Path, default=Path("results"))
    parser.add_argument("--run-id", required=True, help="unique results folder name for this experiment invocation")
    parser.add_argument("--jobs", type=int, default=1, help="maximum concurrent simulations")
    args = parser.parse_args()

    try:
        manifest = args.manifest if args.manifest.is_absolute() else ROOT / args.manifest
        name, jobs = load_jobs(manifest.resolve())
        gem5 = args.gem5 if args.gem5.is_absolute() else ROOT / args.gem5
        gem5 = gem5.resolve()
        if not gem5.is_file():
            raise FileNotFoundError(f"gem5 executable not found: {gem5} (use --gem5)")
        if args.jobs < 1:
            raise ValueError("--jobs must be at least 1")
        output = args.output if args.output.is_absolute() else ROOT / args.output
        run_dir = reserve_run_dir(output, args.run_id)
        print(f"Experiment {name}: {len(jobs)} simulations -> {run_dir}")
        failures = 0
        with concurrent.futures.ThreadPoolExecutor(max_workers=args.jobs) as pool:
            futures = [pool.submit(execute, job, gem5, run_dir) for job in jobs]
            for future in concurrent.futures.as_completed(futures):
                try:
                    failures += future.result() != 0
                except Exception as exc:
                    print(f"ERROR: {exc}", file=sys.stderr)
                    failures += 1
        print(f"Finished: {len(jobs) - failures}/{len(jobs)} simulations succeeded")
        return 1 if failures else 0
    except (OSError, ValueError, tomllib.TOMLDecodeError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
