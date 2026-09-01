#!/usr/bin/env bash

set -euo pipefail

evaluate_health() {
    local cpu_usage="$1"
    local ram_usage="$2"
    local swap_usage="$3"
    local disk_usage="$4"
    local load_avg="$5"
    local cores="$6"
    local temp="$7"
    
    local status="OK"
    local exit_code=0
    
    if [[ "$cpu_usage" -ge "${CPU_CRITICAL_THRESHOLD:-90}" ]]; then
        status="CRITICAL"
        exit_code=2
    elif [[ "$cpu_usage" -ge "${CPU_WARNING_THRESHOLD:-75}" ]] && [[ "$exit_code" -lt 1 ]]; then
        status="WARNING"
        exit_code=1
    fi
    
    if [[ "$ram_usage" -ge "${RAM_CRITICAL_THRESHOLD:-95}" ]]; then
        status="CRITICAL"
        exit_code=2
    elif [[ "$ram_usage" -ge "${RAM_WARNING_THRESHOLD:-80}" ]] && [[ "$exit_code" -lt 1 ]]; then
        status="WARNING"
        exit_code=1
    fi
    
    if [[ "$swap_usage" -ge "${SWAP_CRITICAL_THRESHOLD:-80}" ]]; then
        status="CRITICAL"
        exit_code=2
    elif [[ "$swap_usage" -ge "${SWAP_WARNING_THRESHOLD:-50}" ]] && [[ "$exit_code" -lt 1 ]]; then
        status="WARNING"
        exit_code=1
    fi
    
    if [[ "$disk_usage" -ge "${DISK_CRITICAL_THRESHOLD:-95}" ]]; then
        status="CRITICAL"
        exit_code=2
    elif [[ "$disk_usage" -ge "${DISK_WARNING_THRESHOLD:-80}" ]] && [[ "$exit_code" -lt 1 ]]; then
        status="WARNING"
        exit_code=1
    fi
    
    echo "$status $exit_code"
}
