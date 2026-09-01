#!/usr/bin/env bash

set -euo pipefail

get_listening_ports() {
    if command_exists ss; then
        ss -tuln | awk 'NR>1 {print $1 " " $5}' | sed 's/.*://' | sort -n | uniq
    elif command_exists netstat; then
        netstat -tuln | awk 'NR>2 {print $1 " " $4}' | sed 's/.*://' | sort -n | uniq
    else
        echo "N/A"
    fi
}
