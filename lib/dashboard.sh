#!/usr/bin/env bash

set -euo pipefail

render_dashboard() {
    clear
    
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
    local disk_val
    disk_usage=$(get_disk_usage)
    disk_val=$(echo "$disk_usage" | head -n1 | awk '{print $2}' | tr -d '%')
    
    local health_data
    local health_status
    local exit_code
    
    health_data=$(evaluate_health "${cpu_usage:-0}" "${mem_pct%.*}" "${swap_pct%.*}" "${disk_val:-0}" "$load" "1" "$cpu_temp")
    health_status=$(echo "$health_data" | awk '{print $1}')
    exit_code=$(echo "$health_data" | awk '{print $2}')
    
    local health_color="${COLOR_OK}"
    if [[ "$health_status" == "CRITICAL" ]]; then
        health_color="${COLOR_CRITICAL}"
    elif [[ "$health_status" == "WARNING" ]]; then
        health_color="${COLOR_WARNING}"
    fi

    printf "%bSERVER MONITOR%b\n" "${COLOR_BOLD}" "${COLOR_NORMAL}"
    printf "────────────────────────────────────────────\n"
    printf "Host        : %s\n" "$host"
    printf "OS          : %s\n" "$os"
    printf "Kernel      : %s\n" "$kernel"
    printf "Uptime      : %s\n" "$uptime"
    printf "Load        : %s\n" "$load"
    printf "\n"
    
    printf "%bCPU%b\n" "${COLOR_BOLD}" "${COLOR_NORMAL}"
    printf "────────────────────────────────────────────\n"
    printf "Usage       : %-3s %%  [%s]\n" "$cpu_usage" "$(draw_bar "$cpu_usage")"
    printf "Temperature : %s\n" "$cpu_temp"
    printf "\n"
    
    printf "%bMemory%b\n" "${COLOR_BOLD}" "${COLOR_NORMAL}"
    printf "────────────────────────────────────────────\n"
    printf "RAM         : %s MB / %s MB\n" "$mem_used" "$mem_total"
    printf "Usage       : %-3.0f %%  [%s]\n" "$mem_pct" "$(draw_bar "${mem_pct%.*}")"
    printf "Swap Usage  : %-3.0f %%  [%s]\n" "$swap_pct" "$(draw_bar "${swap_pct%.*}")"
    printf "\n"
    
    printf "%bDisk%b\n" "${COLOR_BOLD}" "${COLOR_NORMAL}"
    printf "────────────────────────────────────────────\n"
    echo "$disk_usage" | while read -r mount pct; do
        if [[ "$pct" != "N/A" ]]; then
            local val="${pct%\%}"
            printf "%-11s : %-3s %%  [%s]\n" "$mount" "$val" "$(draw_bar "$val")"
        else
            printf "%-11s : %s\n" "$mount" "$pct"
        fi
    done
    printf "\n"
    
    printf "%bHealth      : %b%s%b\n" "${COLOR_BOLD}" "${health_color}" "$health_status" "${COLOR_NORMAL}"
    printf "────────────────────────────────────────────\n"
    
    return "$exit_code"
}
