import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import re

def human_format(num):
    """Convierte números grandes en formato legible (1.2k, 1.5M)"""
    if num < 1:
        return f'{num:.2e}' # Notación científica para tiempos muy pequeños
    magnitude = 0
    while abs(num) >= 1000:
        magnitude += 1
        num /= 1000.0
    return '%s%s' % (f'{num:.1f}'.rstrip('0').rstrip('.'), ['', 'k', 'M', 'G', 'T'][magnitude])

def parse_folder_name(name):
    """Extrae modo y tamaño de la carpeta (ej: add_all_cores_128x128)"""
    size_match = re.search(r'(\d+x\d+)$', name)
    size = size_match.group(1) if size_match else "unknown"
    # Extraer el modo limpiando el kernel y el tamaño
    mode = name.replace('add_', '').replace('mul_', '').replace(size, '').strip('_')
    return mode, size

def plot_metrics(metrics, k_name, df_k):
    fig, axes = plt.subplots(3, 1, figsize=(12, 20)) # Aumentamos altura para dar aire
    fig.suptitle(f'Rendimiento Kernel: {k_name.upper()}', fontsize=22, fontweight='bold', y=0.98)
    title = f"Rendimiento del Kernel {k_name.upper()}"

    for i, (col, title, palette) in enumerate(metrics):
        ax = axes[i]
        barplot = sns.barplot(x='Size', y=col, hue='Mode', data=df_k, ax=ax, palette=palette, edgecolor='black')
        
        ax.set_yscale('log')
        ax.set_title(title, fontsize=16, fontweight='bold', pad=20)
        ax.set_ylabel('Valor (Escala Log)')
        ax.set_xlabel('Tamaño de Matriz')
        
        # Ajustar límites de Y para que las etiquetas verticales no se corten arriba
        current_ylim = ax.get_ylim()
        ax.set_ylim(current_ylim[0], current_ylim[1] * 10) # Damos un orden de magnitud más de espacio

        # Mover leyenda fuera
        ax.legend(title='Modo', bbox_to_anchor=(1.02, 1), loc='upper left', borderaxespad=0.)

        # ANOTACIONES VERTICALES
        for p in barplot.patches:
            val = p.get_height()
            if val > 0:
                # Usamos el formateador corto (ej: 151.3k)
                label = human_format(val)
                
                ax.annotate(label, 
                            (p.get_x() + p.get_width() / 2., val), 
                            ha='center', va='bottom', # Alineación: centrado horizontal, base abajo
                            xytext=(0, 5), # 5 puntos de separación de la barra
                            textcoords='offset points',
                            fontsize=7, 
                            fontweight='bold',
                            rotation=0) 

    plt.tight_layout(rect=[0, 0.03, 0.85, 0.95]) # Ajuste para dejar sitio a la leyenda
    output_name = f'graficas_{k_name}.png'
    plt.savefig(output_name, dpi=300)
    print(f"Generada: {output_name}")

def generar_graficas_sin_solapamiento(csv_file):
    try:
        df = pd.read_csv(csv_file)
    except FileNotFoundError:
        print(f"Error: No se encuentra '{csv_file}'.")
        return

    # 1. Procesar nombres
    df[['Mode', 'Size']] = df['folder'].apply(lambda x: pd.Series(parse_folder_name(x)))
    df['Size_num'] = df['Size'].str.extract(r'(\d+)').astype(int)
    df = df.sort_values(['Size_num', 'Mode']).drop_duplicates(subset=['folder'], keep='last')

    sns.set_theme(style="whitegrid")

    for k_name in ['add', 'mul']:
        df_k = df[df['folder'].str.contains(k_name, case=False)].copy()
        if df_k.empty: continue
        metrics = [
            ('sim_seconds', 'Tiempo de Simulación (s)', 'Blues'),
            ('cache_accesses', 'Accesos Cache L1D', 'Reds'),
            ('mem_total_accesses', 'Accesos Memoria Total (Normal+PIM)', 'Greens'),
        ]
        plot_metrics(metrics, k_name, df_k)
        metrics = [
            ('lsq_total_mem_insts', 'Total de Instrucciones de Memoria en LSQ', 'Purples'),
            ('lsq_total_cycles', 'Total de Ciclos en LSQ', 'Oranges'),
            ('lsq_avg_cycles', 'Ciclos Promedio por Instrucción en LSQ', 'Greys'),
        ]
        plot_metrics(metrics, k_name + "_lsq", df_k)
        

if __name__ == "__main__":
    generar_graficas_sin_solapamiento('resumen_gem5.csv')