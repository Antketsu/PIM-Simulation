import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import re
import argparse
from pathlib import Path

OUTPUT_DIR = Path(".")


def human_format(num):
    """Converts large numbers into readable format (1.2k, 1.5M)"""
    if num < 1:
        return f"{num:.2e}"  # Scientific notation for very small time periods
    magnitude = 0
    while abs(num) >= 1000:
        magnitude += 1
        num /= 1000.0
    return "%s%s" % (
        f"{num:.1f}".rstrip("0").rstrip("."),
        ["", "k", "M", "G", "T"][magnitude],
    )


def parse_folder_name(name):
    """Extracts mode and size from the folder name (e.g., add_all_cores_128x128)"""
    size_match = re.search(r"(\d+x\d+)$", name)
    size = size_match.group(1) if size_match else "unknown"
    mode = (
        name.replace("add_", "")
        .replace("mul_", "")
        .replace("gemv_", "")
        .replace(size, "")
        .strip("_")
    )
    return mode, size


def plot_single_metric(col, title, palette, k_name, df_k):
    """Generates and saves an individual plot for a specific metric"""
    if col == "perfect_gaps_pct":
        df_k = df_k[df_k["execution_mode"] == "pim"]
        if df_k.empty:
            return

    if col == "sim_seconds":
        speedup = df_k.pivot_table(
            index="Size", columns="execution_mode", values=col, aggfunc="last"
        )
        if "pim" in speedup.columns:
            speedup_rows = []
            for baseline in ("cpu_sve", "openblas"):
                if baseline not in speedup.columns:
                    continue
                rows = speedup[[baseline, "pim"]].dropna().reset_index()
                rows[col] = rows[baseline] / rows["pim"]
                rows["Mode"] = f"pim_speedup_{baseline}"
                speedup_rows.append(rows[["Size", col, "Mode"]])
            if speedup_rows:
                df_k = pd.concat([df_k, *speedup_rows], ignore_index=True)

    fig, ax = plt.subplots(figsize=(10, 6))

    hue_order = sorted(df_k["Mode"].unique())

    barplot = sns.barplot(
        x="Size",
        y=col,
        hue="Mode",
        hue_order=hue_order,
        data=df_k,
        ax=ax,
        palette=palette,
        edgecolor="black",
    )

    if col == "perfect_gaps_pct":
        ax.set_ylim(0, 110)
        ax.set_yticks(range(0, 101, 10))
    else:
        ax.set_yscale("log")
        current_ylim = ax.get_ylim()
        ax.set_ylim(current_ylim[0], current_ylim[1] * 5)

    ax.set_ylabel(f"{title}", fontsize=11, fontweight="bold")
    if k_name == "gemv":
        ax.set_xlabel("Vector Size x Square Matrix Size", fontsize=11, fontweight="bold")
    elif k_name == "conv":
        ax.set_xlabel("Convolution Layer", fontsize=11, fontweight="bold")
    else:
        ax.set_xlabel("Matrix Size", fontsize=11, fontweight="bold")

    ax.legend(
        bbox_to_anchor=(1.02, 1), loc="upper left", borderaxespad=0.0
    )

    for mode, container in zip(hue_order, barplot.containers):
        labels = []
        is_speedup = col == "sim_seconds" and mode.startswith("pim_speedup_")
        for bar in container:
            val = bar.get_height()
            label = human_format(val) if val > 0 else ""
            if col == "perfect_gaps_pct" and label:
                label = f"{label}%"
            labels.append(f"{label}x" if is_speedup and label else label)
        ax.bar_label(
            container,
            labels=labels,
            label_type="edge",
            padding=6,
            rotation=0,
            fontsize=7,
            fontweight="bold",
            bbox=dict(facecolor="white", edgecolor="none", alpha=0.9, boxstyle="round,pad=0.3"),
        )

    plt.tight_layout()

    output_name = OUTPUT_DIR / f"plot_{k_name}_{col}.png"
    plt.savefig(output_name, dpi=300, bbox_inches="tight")
    plt.close(fig)
    print(f"Generated: {output_name}")

def generar_graficas_sin_solapamiento(csv_file, output_dir=None):
    global OUTPUT_DIR
    csv_file = Path(csv_file).resolve()
    try:
        df = pd.read_csv(csv_file)
    except FileNotFoundError:
        print(f"Error: '{csv_file}' not found.")
        return
    output_root = Path(output_dir).resolve() if output_dir else csv_file.parent

    # Result paths are group/run/mode/case; metadata carries kernel identity.
    parsed = df["folder"].apply(lambda x: pd.Series(parse_folder_name(x)))
    df[["Mode", "Size"]] = parsed
    if "matrix_size" in df:
        df["Size"] = df["matrix_size"].fillna(df["Size"])
    if "execution_mode" in df:
        df = df[df["execution_mode"].isin(["pim", "cpu_sve", "openblas"])].copy()
        mode_names = {"pim": "PIM", "cpu_sve": "CPU SVE", "openblas": "OpenBLAS"}
        df["Mode"] = df["execution_mode"].map(mode_names).fillna(df["Mode"])
    df["Size"] = df["Size"].astype(str)
    df["Size_num"] = pd.to_numeric(df["Size"].str.extract(r"(\d+)")[0], errors="coerce")
    df = df.sort_values(["Size_num", "Mode"]).drop_duplicates(
        subset=["folder"], keep="last"
    )

    sns.set_theme(style="whitegrid")

    # Metrics dictionary translated to English
    all_metrics = [
        ("sim_seconds", "Execution Time (ms)", "Blues"),
        ("l1d_cache_accesses", "L1D Cache Accesses", "Reds"),
        ("l1i_cache_accesses", "L1I Cache Accesses", "Reds"),
        ("l2_cache_accesses", "L2 Cache Accesses", "Reds"),
        ("mem_total_accesses", "Total Memory Accesses", "Greens"),
        ("perfect_gaps_pct", "Perfect Gaps (%)", "Greens"),
        ("lsq_total_mem_insts", "Total Memory Instructions in LSQ", "Purples"),
        ("lsq_total_cycles", "Total Cycles in LSQ", "Oranges"),
        ("lsq_avg_cycles", "Average Cycles per Instruction in LSQ", "Greys"),
    ]

    # Extracted folder values are relative paths such as
    # <run-id>/<mode>/<case>; use the run-id as the plot destination.
    df["result_group"] = df["folder"].astype(str).str.split("/").str[0]
    for result_group, group_df in df.groupby("result_group", sort=True):
        OUTPUT_DIR = output_root / result_group
        OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
        for k_name in ["add", "mul", "gemv", "conv"]:
            if "kernel_type" in group_df:
                if k_name == "conv":
                    df_k = group_df[
                        group_df["kernel_type"].astype(str).str.startswith("conv")
                    ].copy()
                else:
                    df_k = group_df[group_df["kernel_type"] == k_name].copy()
            else:
                df_k = group_df[group_df["folder"].str.contains(k_name, case=False)].copy()
            if df_k.empty:
                continue

            for col, title, palette in all_metrics:
                plot_single_metric(col, title, palette, k_name, df_k)



if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Plot metrics from extracted gem5 statistics.")
    parser.add_argument("csv_file", nargs="?", default="results/summary.csv")
    parser.add_argument("--output-dir", help="plot destination (defaults to the CSV's folder)")
    args = parser.parse_args()
    generar_graficas_sin_solapamiento(args.csv_file, args.output_dir)
