#!/usr/bin/env bash

set -euo pipefail

DESTDIR="${DESTDIR:-}"
PREFIX="${PREFIX:-/usr/local}"
BINDIR="${DESTDIR}${PREFIX}/bin"
LIBDIR="${DESTDIR}${PREFIX}/lib/server-monitor"
CONFDIR="${DESTDIR}/etc"

if [[ $EUID -ne 0 ]] && [[ -z "$DESTDIR" ]]; then
    echo "Please run as root to install system-wide."
    exit 1
fi

echo "Installing Server Monitor..."

mkdir -p "$BINDIR"
mkdir -p "$LIBDIR"
mkdir -p "$CONFDIR"

cp bin/server-monitor "$BINDIR/"
chmod +x "$BINDIR/server-monitor"

cp lib/*.sh "$LIBDIR/"
chmod +x "$LIBDIR/"*.sh

sed -i "s|SM_DIR=\"\${SM_DIR:-.*}\"|SM_DIR=\"${PREFIX}/lib/server-monitor\"|" "$BINDIR/server-monitor"

if [[ ! -f "$CONFDIR/server-monitor.conf" ]]; then
    cp config/server-monitor.conf "$CONFDIR/"
else
    echo "Configuration file already exists at $CONFDIR/server-monitor.conf. Skipping."
fi

echo "Installation complete."
