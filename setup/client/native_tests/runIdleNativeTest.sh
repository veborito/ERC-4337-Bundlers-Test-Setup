#!/usr/bin/env bash
set -euo pipefail

if (( $# != 2 )); then
  echo "Usage: $0 [MACHINE] [PROCESSOR]" >&2
  exit 1
fi

MACHINE="$1"
PROCESSOR="$2"

ssh "$MACHINE" "cd ~/powerexp && ./start_native.sh test-9-$PROCESSOR-idle 12"

#sleep 500

sleep 10

ssh "$MACHINE" "cd ~/powerexp && \
	./stop_native.sh && \
	cd ~/powerexp/results/ \
	&& ./process.sh test-9-$PROCESSOR-idle native"

#sudo cp ~/test-9-$PROCESSOR-idle-pdu.csv ~/Experimental-ERC-4337-Bundler-Setup/power-mesures/sensor_output

