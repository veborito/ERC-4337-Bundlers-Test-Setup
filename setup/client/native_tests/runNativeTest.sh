#!/usr/bin/env bash
set -euo pipefail

if (( $# != 6 )); then
  echo "Usage: $0 [MACHINE] [OUTPUT_FILE] [ROUNDS_TOTAL] [SCA_NUMBER] [THROTTLE_TIME] [BLOCK_TIME]" >&2
  exit 1
fi

MACHINE="$1"
OUTPUT_FILE="$2"

ROUNDS_TOTAL="$3"
SCA_NUMBER="$4"
THROTTLE_TIME="$5"
BLOCK_TIME="$6"

ssh "$MACHINE" "cd ~/powerexp && ./start_native.sh $OUTPUT_FILE $BLOCK_TIME"

npx tsc -p ~/client/tsconfig.json

cd ~/client/dist && node transferUserOpRoundsThrottled.js "$ROUNDS_TOTAL" "$SCA_NUMBER" "$THROTTLE_TIME" "$BLOCK_TIME"

scp -r confirmed_blocks.csv "$MACHINE":~/powerexp/results

sleep 1

ssh "$MACHINE" \
	"sudo mv ~/powerexp/results/confirmed_blocks.csv ~/powerexp/results/sensor_output && \
	cd ~/powerexp && ./stop_native.sh && \
	cd ~/powerexp/results && ./process.sh $OUTPUT_FILE native"

#sudo cp ~/"$output_file_name-pdu.csv" ~/powerexp/results/sensor_output
 
