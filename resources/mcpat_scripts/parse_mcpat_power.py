import sys
import re

def parse_mcpat_power(filename):
    try:
        with open(filename, 'r') as f:
            content = f.read()
            
        # We look specifically for the 'Processor:' section to avoid 
        # accidentally picking up individual core leakage/dynamic power.
        # This regex looks for the first block of results.
        processor_match = re.search(r"Processor:\s*(.*?)\n\n", content, re.DOTALL)
        
        if not processor_match:
            print("Error: Could not find the 'Processor:' header in the output.")
            return

        processor_block = processor_match.group(1)

        # Regex to find floating point numbers followed by 'W'
        leakage_pattern = r"Total Leakage\s*=\s*([\d.e+-]+)\s*W"
        dynamic_pattern = r"Runtime Dynamic\s*=\s*([\d.e+-]+)\s*W"

        leakage_val = re.search(leakage_pattern, processor_block)
        dynamic_val = re.search(dynamic_pattern, processor_block)

        if leakage_val and dynamic_val:
            leakage = float(leakage_val.group(1))
            dynamic = float(dynamic_val.group(1))
            total_power = leakage + dynamic

            print("="*40)
            print("       McPAT POWER ANALYSIS")
            print("="*40)
            print(f"Static Leakage:    {leakage:10.6f} W")
            print(f"Runtime Dynamic:   {dynamic:10.6f} W")
            print("-" * 40)
            print(f"TOTAL POWER:       {total_power:10.6f} W")
            print(f"TOTAL POWER (mW):  {total_power * 1000:10.2f} mW")
            print("="*40)
        else:
            print("Error: Could not find 'Total Leakage' or 'Runtime Dynamic' values.")

    except FileNotFoundError:
        print(f"Error: File '{filename}' not found.")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python parse_mcpat_power.py <mcpat_output_file.txt>")
    else:
        parse_mcpat_power(sys.argv[1])