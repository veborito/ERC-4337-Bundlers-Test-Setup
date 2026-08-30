#!/usr/bin/env bash

set -euo pipefail

if (($# != 2)); then
	echo "Usage: $0 [MACHINE] [PROCESSOR]" >&2
	exit 1
fi

MACHINE="$1"
PROCESSOR="$2"

ssh "$MACHINE" 'cd ~/ERC-4337-Bundlers-Test-Setup/scripts && ./containers/start_containers.sh && cd results && ./power/powerAPI/measure.sh'

#sleep 500
sleep 10

ssh "$MACHINE" "cd ~/ERC-4337-Bundlers-Test-Setup/scripts && ./containers/stop_containers.sh && ./power/powerAPI/process.sh test-9-idle-$PROCESSOR-docker docker"
