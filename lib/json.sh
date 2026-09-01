#!/usr/bin/env bash

set -euo pipefail

generate_json() {
    local host
    local os
    local kernel
    local uptime
    local load
    
    host=$(get_hostname)
    os=$(get_os_info)
    kernel=$(get_kernel_version)
    uptime=$(get_uptime)
    load=$(get_load_average)
    
    local cpu_usage
    local cpu_temp
    
    cpu_usage=$(get_cpu_usage)
    cpu_temp=$(get_cpu_temperature)
    
    local mem_info
    local swap_info
    local mem_total
    local mem_used
    local mem_pct
    local swap_total
    local swap_used
    local swap_pct
    
    mem_info=$(get_memory_info)
    swap_info=$(get_swap_info)
    
    mem_total=$(echo "$mem_info" | awk '{print $1}')
    mem_used=$(echo "$mem_info" | awk '{print $2}')
    mem_pct=$(echo "$mem_info" | awk '{print $3}')
    
    swap_total=$(echo "$swap_info" | awk '{print $1}')
    swap_used=$(echo "$swap_info" | awk '{print $2}')
    swap_pct=$(echo "$swap_info" | awk '{print $3}')
    
    local disk_usage
    disk_usage=$(get_disk_usage | head -n1 | awk '{print $2}' | tr -d '%')
    
    local health_data
    local health_status
    local exit_code
    
    health_data=$(evaluate_health "${cpu_usage:-0}" "${mem_pct%.*}" "${swap_pct%.*}" "${disk_usage:-0}" "$load" "1" "$cpu_temp")
    health_status=$(echo "$health_data" | awk '{print $1}')
    exit_code=$(echo "$health_data" | awk '{print $2}')
    
    cat <<EOF
{
  "system": {
    "hostname": "$host",
    "os": "$os",
    "kernel": "$kernel",
    "uptime": "$uptime",
    "load_average": "$load"
  },
  "cpu": {
    "usage_percent": $cpu_usage,
    "temperature": "$cpu_temp"
  },
  "memory": {
    "total_mb": $mem_total,
    "used_mb": $mem_used,
    "usage_percent": $mem_pct,
    "swap_total_mb": $swap_total,
    "swap_used_mb": $swap_used,
    "swap_usage_percent": $swap_pct
  },
  "disk": {
    "root_usage_percent": ${disk_usage:-0}
  },
  "health": {
    "status": "$health_status",
    "exit_code": $exit_code
  }
}
EOF
    return "$exit_code"
}
