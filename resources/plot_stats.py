import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

def generar_graficas_log(csv_file):
    try:
        df = pd.read_csv(csv_file)
    except FileNotFoundError:
        print(f"Error: No se encuentra '{csv_file}'.")
        return

    # Configuramos el estilo
    sns.set_theme(style="whitegrid")
    fig, axes = plt.subplots(3, 1, figsize=(12, 18)) # 3 filas, 1 columna para que sean más anchas
    fig.suptitle('Comparativa de Estadísticas gem5 (Escala Logarítmica)', fontsize=20)

    metrics = [
        ('sim_seconds', 'Tiempo de Simulación (s)', 'Blues_d'),
        ('cache_accesses', 'Accesos a Cache L1D', 'Reds_d'),
        ('mem_total_accesses', 'Accesos a Memoria (DRAM+PIM)', 'Greens_d')
    ]

    for i, (col, title, palette) in enumerate(metrics):
        ax = axes[i]
        
        # Crear la gráfica de barras
        # Usamos log=True para que los valores pequeños sean visibles
        barplot = sns.barplot(x='folder', y=col, data=df, ax=ax, palette=palette)
        
        # Configurar escala logarítmica
        ax.set_yscale('log')
        ax.set_title(title, fontsize=16)
        ax.set_ylabel('Valor (Escala Log)')
        ax.set_xlabel('Carpeta / Configuración')
        
        # Rotar nombres de carpetas
        ax.tick_params(axis='x', rotation=45)

        # Añadir etiquetas de texto sobre las barras para ver el número real
        for p in barplot.patches:
            val = p.get_height()
            if val > 0:
                # Formatear: si es muy pequeño usa notación científica, si es grande usa comas
                label = f'{val:.2e}' if val < 0.1 else f'{int(val):,}'
                ax.annotate(label, 
                            (p.get_x() + p.get_width() / 2., val), 
                            ha = 'center', va = 'center', 
                            xytext = (0, 9), 
                            textcoords = 'offset points',
                            fontsize=10, fontweight='bold')

    plt.tight_layout(rect=[0, 0.03, 1, 0.96])
    
    # Guardar y mostrar
    output_img = 'graficas_log_detalladas.png'
    plt.savefig(output_img, dpi=300)
    print(f"Gráfica guardada como '{output_img}'")
    plt.show()

if __name__ == "__main__":
    generar_graficas_log('resumen_gem5.csv')