#!/usr/bin/env bash

set -euo pipefail

get_cpu_usage() {
    if command_exists top; then
        top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}' | awk '{printf "%.0f\n", $1}'
    else
        echo "0"
    fi
}

get_cpu_temperature() {
    if [[ -f /sys/class/thermal/thermal_zone0/temp ]]; then
        awk '{printf "%.1f°C\n", $1/1000}' /sys/class/thermal/thermal_zone0/temp
    elif command_exists sensors; then
        local temp
        temp=$(sensors 2>/dev/null | grep -E 'Core 0|temp1' | head -n1 | awk '{print $3}' | tr -d '+')
        if [[ -n "$temp" ]]; then
            echo "$temp"
        else
            echo "N/A"
        fi
    else
        echo "N/A"
    fi
}

get_cpu_info() {
    if [[ -f /proc/cpuinfo ]]; then
        grep "model name" /proc/cpuinfo | head -n1 | cut -d':' -f2 | sed 's/^ *//'
    else
        echo "Unknown"
    fi
}
