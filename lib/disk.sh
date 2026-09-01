#!/usr/bin/env bash

set -euo pipefail

get_disk_usage() {
    if command_exists df; then
        df -h -T -x tmpfs -x devtmpfs -x squashfs | grep -v 'Type' | awk '{print $7 " " $5}'
    else
        echo "/" "N/A"
    fi
}

get_disk_io() {
    if command_exists iostat; then
        iostat -d 1 1 | awk 'NR>3 {if ($1 != "") print $1 " " $3 " " $4}'
    else
        echo "N/A N/A N/A"
    fi
}
