#!/usr/bin/env bash

set -euo pipefail

DESTDIR="${DESTDIR:-}"
PREFIX="${PREFIX:-/usr/local}"
BINDIR="${DESTDIR}${PREFIX}/bin"
LIBDIR="${DESTDIR}${PREFIX}/lib/server-monitor"
CONFDIR="${DESTDIR}/etc"

if [[ $EUID -ne 0 ]] && [[ -z "$DESTDIR" ]]; then
    echo "Please run as root to uninstall."
    exit 1
fi

echo "Uninstalling Server Monitor..."

rm -f "$BINDIR/server-monitor"
rm -rf "$LIBDIR"

echo "Note: Configuration at $CONFDIR/server-monitor.conf was kept."
echo "Uninstallation complete."
