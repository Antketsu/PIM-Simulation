import re
import sys
import matplotlib.pyplot as plt

def get_sim_seconds(stats_file):
    """Extracts simSeconds from gem5 stats.txt"""
    try:
        with open(stats_file, 'r') as f:
            for line in f:
                if 'simSeconds' in line:
                    # Finds the first decimal number in the line
                    match = re.search(r"(\d+\.\d+)", line)
                    if match:
                        return float(match.group(1))
    except FileNotFoundError:
        print(f"Error: gem5 stats file '{stats_file}' not found.")
    return None

def get_mcpat_power(mcpat_file):
    """Extracts Leakage and Dynamic power from McPAT output"""
    try:
        with open(mcpat_file, 'r') as f:
            content = f.read()
            
        # Get the top-level Processor block
        processor_match = re.search(r"Processor:\s*(.*?)\n\n", content, re.DOTALL)
        if not processor_match:
            return None, None

        block = processor_match.group(1)
        leakage = float(re.search(r"Total Leakage\s*=\s*([\d.e+-]+)\s*W", block).group(1))
        dynamic = float(re.search(r"Runtime Dynamic\s*=\s*([\d.e+-]+)\s*W", block).group(1))
        
        return leakage, dynamic
    except Exception as e:
        print(f"Error parsing McPAT file: {e}")
    return None, None

def create_graphics(sim_time, leakage, dynamic):
    total_power = leakage + dynamic
    total_energy = total_power * sim_time # Energy in Joules

    # Data for the plots
    labels = ['Static Leakage', 'Runtime Dynamic']
    powers = [leakage, dynamic]
    colors = ['#ff9999','#66b3ff']

    # Create a figure with two subplots
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 6))

    # Plot 1: Power Breakdown (Pie Chart)
    ax1.pie(powers, labels=labels, autopct='%1.1f%%', startangle=140, colors=colors, explode=(0.05, 0))
    ax1.set_title(f"Power Breakdown\nTotal: {total_power:.4f} W")

    # Plot 2: Energy Analysis (Bar Chart)
    # We plot the energy contribution
    energies = [leakage * sim_time, dynamic * sim_time]
    ax2.bar(labels, energies, color=colors)
    ax2.set_ylabel('Energy (Joules)')
    ax2.set_title(f"Energy Consumption\nTotal: {total_energy:.6f} J")
    
    # Add info text box
    info_text = (f"Simulated Time: {sim_time:.6f} s\n"
                 f"Avg Power: {total_power*1000:.2f} mW\n"
                 f"Total Energy: {total_energy*1000:.4f} mJ")
    plt.figtext(0.5, 0.02, info_text, ha="center", fontsize=10, bbox={"facecolor":"orange", "alpha":0.2, "pad":5})

    plt.tight_layout(rect=[0, 0.05, 1, 0.95])
    
    # Save and Show
    output_png = "power_analysis_report.png"
    plt.savefig(output_png)
    print(f"Graphic saved as {output_png}")
    plt.show()

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python gem5_mcpat_visualizer.py <gem5_stats.txt> <mcpat_output.txt>")
        sys.exit(1)

    time = get_sim_seconds(sys.argv[1])
    leak, dyn = get_mcpat_power(sys.argv[2])

    if time and leak is not None:
        create_graphics(time, leak, dyn)
    else:
        print("Failed to extract necessary data.")