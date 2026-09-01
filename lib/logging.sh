#!/usr/bin/env bash

set -euo pipefail

log_event() {
    local level="$1"
    local message="$2"
    
    if [[ "${LOGGING_ENABLED:-0}" -eq 1 ]]; then
        local log_file="${LOG_FILE:-/var/log/server-monitor.log}"
        local timestamp
        timestamp=$(date "+%Y-%m-%d %H:%M:%S")
        
        if [[ -w "$log_file" ]] || touch "$log_file" 2>/dev/null; then
            printf "[%s] [%s] %s\n" "$timestamp" "$level" "$message" >> "$log_file"
        fi
    fi
}

log_info() {
    log_event "INFO" "$1"
}

log_warning() {
    log_event "WARNING" "$1"
}

log_critical() {
    log_event "CRITICAL" "$1"
}
