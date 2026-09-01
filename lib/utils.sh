#!/usr/bin/env bash

set -euo pipefail

COLOR_NORMAL='\033[0m'
COLOR_INFO='\033[1;34m'
COLOR_OK='\033[1;32m'
COLOR_WARNING='\033[1;33m'
COLOR_CRITICAL='\033[1;31m'
COLOR_BOLD='\033[1m'

print_normal() {
    printf "%b%s%b\n" "${COLOR_NORMAL}" "$*" "${COLOR_NORMAL}"
}

print_info() {
    printf "%b%s%b\n" "${COLOR_INFO}" "$*" "${COLOR_NORMAL}"
}

print_ok() {
    printf "%b%s%b\n" "${COLOR_OK}" "$*" "${COLOR_NORMAL}"
}

print_warning() {
    printf "%b%s%b\n" "${COLOR_WARNING}" "$*" "${COLOR_NORMAL}"
}

print_critical() {
    printf "%b%s%b\n" "${COLOR_CRITICAL}" "$*" "${COLOR_NORMAL}"
}

print_bold() {
    printf "%b%s%b\n" "${COLOR_BOLD}" "$*" "${COLOR_NORMAL}"
}

die() {
    print_critical "$1" >&2
    exit "${2:-1}"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

draw_bar() {
    local percent=$1
    local width=${2:-20}
    local filled
    local empty
    local bar
    local color

    if [[ "$percent" -ge 90 ]]; then
        color="${COLOR_CRITICAL}"
    elif [[ "$percent" -ge 75 ]]; then
        color="${COLOR_WARNING}"
    else
        color="${COLOR_OK}"
    fi

    filled=$(( (percent * width) / 100 ))
    empty=$(( width - filled ))

    bar="$(printf "%${filled}s" | tr ' ' '█')"
    bar="${bar}$(printf "%${empty}s" | tr ' ' '░')"

    printf "%b%s%b" "${color}" "${bar}" "${COLOR_NORMAL}"
}
