#!/bin/bash

# Check if program name is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <program_command>"
    exit 1
fi

# Create output file with timestamp
timestamp=$(date +"%Y%m%d_%H%M%S")
output_file="ram_usage_${timestamp}.log"

# Write header to output file
echo "Timestamp,RAM_Used_MB,RAM_Free_MB,Program_RAM_MB" > "$output_file"

# Run the provided program in background
eval "$@" &
program_pid=$!

# Monitor RAM usage every second
while ps -p $program_pid > /dev/null; do
    # Get total used and free RAM
    total_used=$(free -m | awk 'NR==2 {print $3}')
    total_free=$(free -m | awk 'NR==2 {print $4}')
    
    # Get program specific RAM usage
    program_ram=$(ps -p $program_pid -o rss= | awk '{print $1/1024}')
    
    # Write to log file
    echo "$(date '+%Y-%m-%d %H:%M:%S'),$total_used,$total_free,$program_ram" >> "$output_file"
    
    sleep 1
done

echo "Monitoring complete. Results saved to $output_file"

# Optional: Convert to CSV format for easy analysis
echo "Converting to CSV format..."
awk -F',' '{printf "%.2f,%.2f,%.2f\n", $2,$3,$4}' "$output_file" > "${output_file%.log}_data.csv"



# To Use
# ```
# chmod +x monitor_ram.sh
# ./monitor_ram.sh "python my_script.py"
#```
#
#
