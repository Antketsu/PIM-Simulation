import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import re


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
    mode = name.replace("add_", "").replace("mul_", "").replace(size, "").strip("_")
    if mode == "no_acc_opt":
        mode = "cpu_vect"
    return mode, size


def add_difference_rows(df, col):
    """Add a computed Difference row for each size when exactly two modes exist."""
    pivot = df.pivot(index="Size", columns="Mode", values=col)
    if pivot.shape[1] != 2:
        return df

    pivot = pivot[pivot.columns.sort_values()]
    diff = (pivot.iloc[:, 1] - pivot.iloc[:, 0]).abs().dropna()
    if diff.empty:
        return df

    diff_df = diff.reset_index(name=col)
    diff_df["Mode"] = "Difference"
    return pd.concat([df, diff_df], ignore_index=True, sort=False)


def plot_single_metric(col, title, palette, k_name, df_k):
    """Generates and saves an individual plot for a specific metric"""
    fig, ax = plt.subplots(figsize=(10, 6))

    hue_order = sorted(df_k["Mode"].unique())
    if "Difference" in hue_order:
        hue_order = [m for m in hue_order if m != "Difference"] + ["Difference"]

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

    ax.set_yscale("log")
    ax.set_ylabel(f"{title}", fontsize=11, fontweight="bold")
    if k_name == "gemv":
        ax.set_xlabel("Vector Size x Square Matrix Size", fontsize=11, fontweight="bold")
    else:
        ax.set_xlabel("Matrix Size", fontsize=11, fontweight="bold")

    current_ylim = ax.get_ylim()
    ax.set_ylim(current_ylim[0], current_ylim[1] * 5)

    ax.legend(
        bbox_to_anchor=(1.02, 1), loc="upper left", borderaxespad=0.0
    )

    for container in barplot.containers:
        labels = []
        for bar in container:
            val = bar.get_height()
            labels.append(human_format(val) if val > 0 else "")
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

    output_name = f"plot_{k_name}_{col}.png"
    plt.savefig(output_name, dpi=300, bbox_inches="tight")
    plt.close(fig)
    print(f"Generated: {output_name}")

def generar_graficas_sin_solapamiento(csv_file):
    try:
        df = pd.read_csv(csv_file)
    except FileNotFoundError:
        print(f"Error: '{csv_file}' not found.")
        return

    # 1. Process folder names
    df[["Mode", "Size"]] = df["folder"].apply(lambda x: pd.Series(parse_folder_name(x)))
    df["Size_num"] = df["Size"].str.extract(r"(\d+)").astype(int)
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
        ("lsq_total_mem_insts", "Total Memory Instructions in LSQ", "Purples"),
        ("lsq_total_cycles", "Total Cycles in LSQ", "Oranges"),
        ("lsq_avg_cycles", "Average Cycles per Instruction in LSQ", "Greys"),
    ]

    for k_name in ["add", "mul", "gemv"]:
        df_k = df[df["folder"].str.contains(k_name, case=False)].copy()
        if df_k.empty:
            continue

        for col, title, palette in all_metrics:
            df_plot = add_difference_rows(df_k, col)
            plot_single_metric(col, title, palette, k_name, df_plot)



if __name__ == "__main__":
    generar_graficas_sin_solapamiento("resumen_gem5.csv")
