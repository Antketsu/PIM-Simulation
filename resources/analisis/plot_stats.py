import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import re

def human_format(num):
    """Converts large numbers into readable format (1.2k, 1.5M)"""
    if num < 1:
        return f'{num:.2e}' # Scientific notation for very small time periods
    magnitude = 0
    while abs(num) >= 1000:
        magnitude += 1
        num /= 1000.0
    return '%s%s' % (f'{num:.1f}'.rstrip('0').rstrip('.'), ['', 'k', 'M', 'G', 'T'][magnitude])

def parse_folder_name(name):
    """Extracts mode and size from the folder name (e.g., add_all_cores_128x128)"""
    size_match = re.search(r'(\d+x\d+)$', name)
    size = size_match.group(1) if size_match else "unknown"
    mode = name.replace('add_', '').replace('mul_', '').replace(size, '').strip('_')
    return mode, size

def plot_single_metric(col, title, palette, k_name, df_k):
    """Generates and saves an individual plot for a specific metric"""
    fig, ax = plt.subplots(figsize=(10, 6))
    
    # Title in English
    ax.set_title(f'Kernel: {k_name.upper()} - {title}', fontsize=14, fontweight='bold', pad=15)
    
    # Draw the barplot
    barplot = sns.barplot(x='Size', y=col, hue='Mode', data=df_k, ax=ax, palette=palette, edgecolor='black')
    
    ax.set_yscale('log')
    ax.set_ylabel('Value (Log Scale)', fontsize=11)
    if k_name == 'gemv':
        ax.set_xlabel('Vector Size x Square Matrix Size', fontsize=11)
    else:
        ax.set_xlabel('Matrix Size', fontsize=11)
    
    # Adjust Y limits to give space for labels at the top
    current_ylim = ax.get_ylim()
    ax.set_ylim(current_ylim[0], current_ylim[1] * 5)

    # Move legend outside the plot area
    ax.legend(title='Mode', bbox_to_anchor=(1.02, 1), loc='upper left', borderaxespad=0.)

    # Vertical annotations on top of each bar
    for p in barplot.patches:
        val = p.get_height()
        if val > 0:
            label = human_format(val)
            ax.annotate(label, 
                        (p.get_x() + p.get_width() / 2., val), 
                        ha='center', va='bottom', 
                        xytext=(0, 4), 
                        textcoords='offset points',
                        fontsize=8, 
                        fontweight='bold') 

    plt.tight_layout()
    
    # Output file name structure
    output_name = f'plot_{k_name}_{col}.png'
    plt.savefig(output_name, dpi=300, bbox_inches='tight')
    plt.close(fig) # Free RAM memory
    print(f"Generated: {output_name}")

def generar_graficas_sin_solapamiento(csv_file):
    try:
        df = pd.read_csv(csv_file)
    except FileNotFoundError:
        print(f"Error: '{csv_file}' not found.")
        return

    # 1. Process folder names
    df[['Mode', 'Size']] = df['folder'].apply(lambda x: pd.Series(parse_folder_name(x)))
    df['Size_num'] = df['Size'].str.extract(r'(\d+)').astype(int)
    df = df.sort_values(['Size_num', 'Mode']).drop_duplicates(subset=['folder'], keep='last')

    sns.set_theme(style="whitegrid")

    # Metrics dictionary translated to English
    all_metrics = [
        ('sim_seconds', 'Execution Time (s)', 'Blues'),
        ('cache_accesses', 'L1D Cache Accesses', 'Reds'),
        ('mem_total_accesses', 'Total Memory Accesses (Normal+PIM)', 'Greens'),
        ('lsq_total_mem_insts', 'Total Memory Instructions in LSQ', 'Purples'),
        ('lsq_total_cycles', 'Total Cycles in LSQ', 'Oranges'),
        ('lsq_avg_cycles', 'Average Cycles per Instruction in LSQ', 'Greys'),
    ]

    for k_name in ['add', 'mul', 'gemv']:
        df_k = df[df['folder'].str.contains(k_name, case=False)].copy()
        if df_k.empty: 
            continue
        
        for col, title, palette in all_metrics:
            plot_single_metric(col, title, palette, k_name, df_k)
        

if __name__ == "__main__":
    generar_graficas_sin_solapamiento('resumen_gem5.csv')