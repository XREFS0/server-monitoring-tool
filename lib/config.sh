#!/usr/bin/env bash

set -euo pipefail

load_config() {
    local config_file="$1"
    
    if [[ -f "$config_file" ]]; then
        while IFS='=' read -r key value; do
            if [[ -n "$key" && "$key" != \#* ]]; then
                value="${value%\"}"
                value="${value#\"}"
                value="${value%\'}"
                value="${value#\'}"
                export "$key=$value"
            fi
        done < "$config_file"
    fi
}

init_config() {
    local default_config="${SM_DIR:-}/config/server-monitor.conf"
    local user_config="/etc/server-monitor.conf"
    
    load_config "$default_config"
    load_config "$user_config"
}
