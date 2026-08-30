#!/usr/bin/env bash
set -euo pipefail

# change this thing with getops and parameter extension
if (($# < 8 || $# > 9)); then
	echo "Usage: $0 [NODE_MACHINE] [BUNDLER_MACHINE] [MAC_ADDRESS] [BUNDLER: optional]" >&2
	exit 1
fi

NODE_MACHINE="$1"
BUNDLER_MACHINE="$2"
MAC_ADDRESS="$3"
BUNDLER=${4:-alto}

ssh "$NODE_MACHINE" 'cd ~/ERC-4337-Bundlers-Test-Setup/scripts/containers && ./start_node_container.sh && cd ~/ERC-4337-Bundlers-Test-Setup/scripts/power/powerAPI && ./measure.sh'

ssh "$BUNDLER_MACHINE" "cd ~/ERC-4337-Bundlers-Test-Setup/scripts/raspi && ./start_and_measure.sh $MAC_ADDRESS raspi-$BUNDLER-idle $BUNDLER"

echo "everything started smoothly..."

sleep 500

ssh "$NODE_MACHINE" "cd ~/ERC-4337-Bundlers-Test-Setup/scripts && ./containers/stop_containers.sh && ./power/powerAPI/process.sh raspi-$BUNDLER-idle raspi"

ssh "$BUNDLER_MACHINE" "cd ~/ERC-4337-Bundlers-Test-Setup/scripts/raspi && ./stop_all.sh"

echo "everything stoped gracefully..."
