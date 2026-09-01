#!/usr/bin/env bash

set -euo pipefail

get_memory_info() {
    if command_exists free; then
        free -m | awk 'NR==2{printf "%s %s %.2f\n", $3, $2, $3*100/$2}'
    else
        echo "0 0 0"
    fi
}

get_swap_info() {
    if command_exists free; then
        free -m | awk 'NR==3{if($2>0) printf "%s %s %.2f\n", $3, $2, $3*100/$2; else print "0 0 0"}'
    else
        echo "0 0 0"
    fi
}
