#!/usr/bin/env bash

set -euo pipefail

get_network_interfaces() {
    if command_exists ip; then
        ip -o link show | awk -F': ' '{print $2}' | grep -v 'lo'
    elif command_exists ifconfig; then
        ifconfig -a | sed 's/[ \t].*//;/^\(lo\|\)$/d' | grep -v '^$'
    fi
}

get_network_traffic() {
    local interface="$1"
    if [[ -f "/sys/class/net/$interface/statistics/rx_bytes" ]]; then
        local rx
        local tx
        rx=$(cat "/sys/class/net/$interface/statistics/rx_bytes")
        tx=$(cat "/sys/class/net/$interface/statistics/tx_bytes")
        echo "$rx $tx"
    else
        echo "0 0"
    fi
}
