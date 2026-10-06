#!/usr/bin/env python3
"""Plot the ticks-between-instructions histogram from a gem5 stats file."""

import argparse
import re
from pathlib import Path

import matplotlib.pyplot as plt


HISTOGRAM_NAME = "board.pim.mem_ctrl.dram.hist_ticks_between_instrs"
BIN_PATTERN = re.compile(r"^(\d+)-(\d+)$")


def read_stat_blocks(stats_path: Path) -> list[list[str]]:
    """Return the contents of each simulation-statistics block."""
    blocks: list[list[str]] = []
    current: list[str] | None = None

    with stats_path.open(encoding="utf-8") as stats_file:
        for line in stats_file:
            if "Begin Simulation Statistics" in line:
                current = []
                continue
            if "End Simulation Statistics" in line:
                if current is not None:
                    blocks.append(current)
                    current = None
                continue
            if current is not None:
                current.append(line)

    return blocks


def parse_histogram(block: list[str]) -> tuple[list[int], list[int], list[int]]:
    """Extract lower bounds, bin widths, and counts from one stats block."""
    lower_bounds: list[int] = []
    widths: list[int] = []
    counts: list[int] = []
    prefix = f"{HISTOGRAM_NAME}::"

    for line in block:
        fields = line.split()
        if len(fields) < 2 or not fields[0].startswith(prefix):
            continue

        match = BIN_PATTERN.fullmatch(fields[0][len(prefix) :])
        if not match:
            continue

        lower = int(match.group(1))
        upper = int(match.group(2))
        count = int(fields[1])
        lower_bounds.append(lower)
        widths.append(upper - lower + 1)
        counts.append(count)

    if not counts:
        raise ValueError(f"No se encontró {HISTOGRAM_NAME} en el bloque seleccionado")

    return lower_bounds, widths, counts


def plot_histogram(
    lower_bounds: list[int],
    widths: list[int],
    counts: list[int],
    output_path: Path,
    block_number: int,
    total_blocks: int,
    ylabel: str,
    title_suffix: str,
) -> None:
    upper_bounds = [lower + width - 1 for lower, width in zip(lower_bounds, widths)]
    values = counts if ylabel == "Frecuencia" else [
        count * 100 / sum(counts) for count in counts
    ]

    fig, axis = plt.subplots(figsize=(12, 6))
    axis.bar(
        lower_bounds,
        values,
        width=widths,
        align="edge",
        edgecolor="black",
        linewidth=0.6,
        color="#2f7f8f",
    )
    axis.set_xlabel("Ticks entre instrucciones")
    axis.set_ylabel(ylabel)
    axis.set_title(
        "Histograma de ticks entre instrucciones "
        f"({title_suffix}, bloque {block_number + 1} de {total_blocks})"
    )
    axis.grid(axis="y", alpha=0.25)

    # Show readable labels without putting every zero-count bin on the axis.
    nonzero = [
        (lower, upper, count)
        for lower, upper, count in zip(lower_bounds, upper_bounds, counts)
        if count > 0
    ]
    axis.set_xticks([lower for lower, _, _ in nonzero])
    axis.set_xticklabels(
        [f"{lower}-{upper}" for lower, upper, _ in nonzero],
        rotation=60,
        ha="right",
    )
    axis.margins(x=0.01)
    fig.tight_layout()
    fig.savefig(output_path, dpi=300, bbox_inches="tight")
    plt.close(fig)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Genera un histograma desde hist_ticks_between_instrs de gem5."
    )
    parser.add_argument("stats", type=Path, help="Ruta al archivo stats.txt")
    parser.add_argument(
        "--block",
        choices=("first", "last"),
        default="last",
        help="Bloque de estadísticas a usar (por defecto: last)",
    )
    parser.add_argument(
        "--output",
        type=Path,
        help="PNG de salida (por defecto: junto a stats.txt)",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    stats_path = args.stats.resolve()
    blocks = read_stat_blocks(stats_path)
    if not blocks:
        raise SystemExit("Error: no se encontraron bloques de estadísticas")

    block_number = 0 if args.block == "first" else len(blocks) - 1
    lower_bounds, widths, counts = parse_histogram(blocks[block_number])
    output_path = args.output or stats_path.with_name(
        f"{stats_path.stem}_hist_ticks_between_instrs_frequency.png"
    )
    percentage_path = output_path.with_name(
        f"{output_path.stem}_percentage{output_path.suffix}"
    )

    plot_histogram(
        lower_bounds,
        widths,
        counts,
        output_path,
        block_number,
        len(blocks),
        "Frecuencia",
        "frecuencia absoluta",
    )
    plot_histogram(
        lower_bounds,
        widths,
        counts,
        percentage_path,
        block_number,
        len(blocks),
        "Porcentaje (%)",
        "porcentaje",
    )
    print(f"Histograma de frecuencia generado: {output_path}")
    print(f"Histograma de porcentaje generado: {percentage_path}")


if __name__ == "__main__":
    main()
