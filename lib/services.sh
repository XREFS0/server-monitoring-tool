#!/usr/bin/env bash

set -euo pipefail

check_service_systemd() {
    local service="$1"
    if systemctl is-active --quiet "$service"; then
        echo "Active"
    elif systemctl is-failed --quiet "$service"; then
        echo "Failed"
    else
        echo "Inactive"
    fi
}

get_service_status() {
    local services="$1"
    if command_exists systemctl; then
        for svc in $services; do
            echo "$svc $(check_service_systemd "$svc")"
        done
    else
        echo "systemd not available"
    fi
}

get_failed_services() {
    if command_exists systemctl; then
        systemctl --failed --no-legend | awk '{print $1}'
    else
        echo ""
    fi
}
