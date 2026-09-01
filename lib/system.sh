#!/usr/bin/env bash

set -euo pipefail

get_hostname() {
    hostname 2>/dev/null || cat /etc/hostname 2>/dev/null || echo "Unknown"
}

get_os_info() {
    if [[ -f /etc/os-release ]]; then
        grep -E '^PRETTY_NAME=' /etc/os-release | cut -d '"' -f 2
    elif command_exists lsb_release; then
        lsb_release -d -s
    else
        uname -s
    fi
}

get_kernel_version() {
    uname -r
}

get_uptime() {
    if command_exists uptime; then
        uptime -p 2>/dev/null || uptime | awk -F'( |,|:)+' '{print $6 " days " $8 " hours " $9 " mins"}'
    else
        cat /proc/uptime | awk '{printf "%.2f days\n", $1/60/60/24}'
    fi
}

get_load_average() {
    if [[ -f /proc/loadavg ]]; then
        awk '{print $1, $2, $3}' /proc/loadavg
    else
        uptime | awk -F'load average:' '{print $2}' | sed 's/ //g; s/,/ /g'
    fi
}
