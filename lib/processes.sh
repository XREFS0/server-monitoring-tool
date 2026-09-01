#!/usr/bin/env bash

set -euo pipefail

get_top_cpu_processes() {
    local count="${1:-5}"
    if command_exists ps; then
        ps -eo pid,user,%cpu,%mem,time,comm --sort=-%cpu | head -n "$((count + 1))"
    fi
}

get_top_memory_processes() {
    local count="${1:-5}"
    if command_exists ps; then
        ps -eo pid,user,%cpu,%mem,time,comm --sort=-%mem | head -n "$((count + 1))"
    fi
}

get_process_count() {
    if command_exists ps; then
        ps -e | wc -l
    else
        echo "0"
    fi
}

get_zombie_count() {
    if command_exists ps; then
        ps -eo stat | grep -w 'Z' | wc -l
    else
        echo "0"
    fi
}
