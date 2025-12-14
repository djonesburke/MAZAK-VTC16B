#!/bin/bash
# VTC16B LinuxCNC Launch Script
# Usage: ./run-vtc16b.sh

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_FILE="$REPO_ROOT/configs/vtc16b/vtc16b.ini"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Config file not found at $CONFIG_FILE"
    exit 1
fi

echo "Launching LinuxCNC VTC16B configuration..."
echo "Config: $CONFIG_FILE"

linuxcnc "$CONFIG_FILE"
