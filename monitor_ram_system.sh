#!/bin/bash

# Create output file with timestamp
timestamp=$(date +"%Y%m%d_%H%M%S")
output_file="system_ram_${timestamp}.log"

# Write header to output file
echo "Timestamp,Total_RAM_MB,Used_RAM_MB,Free_RAM_MB,Cached_MB,Swap_Used_MB" > "$output_file"

# Function to convert bytes to MB
bytes_to_mb() {
    echo "scale=2; $1/1024/1024" | bc
}

# Handle script termination
trap 'echo -e "\nMonitoring stopped. Results saved to $output_file"; exit' INT TERM

echo "Starting RAM monitoring... (Press Ctrl+C to stop)"
echo "Logging to: $output_file"
echo "Time            Total    Used     Free    Cached   Swap"

while true; do
    # Get current memory statistics
    mem_total=$(free -b | awk 'NR==2 {print $2}')
    mem_used=$(free -b | awk 'NR==2 {print $3}')
    mem_free=$(free -b | awk 'NR==2 {print $4}')
    mem_cached=$(free -b | awk 'NR==2 {print $6}')
    swap_used=$(free -b | awk 'NR==3 {print $3}')
    
    # Convert to MB
    total_mb=$(bytes_to_mb $mem_total)
    used_mb=$(bytes_to_mb $mem_used)
    free_mb=$(bytes_to_mb $mem_free)
    cached_mb=$(bytes_to_mb $mem_cached)
    swap_mb=$(bytes_to_mb $swap_used)
    
    # Get timestamp
    current_time=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Write to log file
    echo "$current_time,$total_mb,$used_mb,$free_mb,$cached_mb,$swap_mb" >> "$output_file"
    
    # Display current status
    printf "\r%s  %6.1fG  %6.1fG  %6.1fG  %6.1fG  %6.1fG" \
        "$(date '+%H:%M:%S')" \
        "$(echo "$total_mb/1024" | bc -l)" \
        "$(echo "$used_mb/1024" | bc -l)" \
        "$(echo "$free_mb/1024" | bc -l)" \
        "$(echo "$cached_mb/1024" | bc -l)" \
        "$(echo "$swap_mb/1024" | bc -l)"
    
    sleep 1
done

# To use
# ```
# chmod +x monitor_system_ram.sh
# ./monitor_system_ram.sh
# ```
#
#
#
