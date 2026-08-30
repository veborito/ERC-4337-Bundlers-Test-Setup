#!/usr/bin/env bash
set -euo pipefail

if (($# != 6)); then
	echo "Usage: $0 [MACHINE] [OUTPUT_FILE] [ROUNDS_TOTAL] [SCA_NUMBER] [THROTTLE_TIME] [BLOCK_TIME]" >&2
	exit 1
fi

MACHINE="$1"
OUTPUT_FILE="$2"

ROUNDS_TOTAL="$3"
SCA_NUMBER="$4"
THROTTLE_TIME="$5"
BLOCK_TIME="$6"

cd ~/ERC-4337-Bundlers-Test-Setup/client/
npx tsc -p ./tsconfig.json

ssh "$MACHINE" "cd ~/ERC-4337-Bundlers-Test-Setup/scripts/native && ./start_native.sh $OUTPUT_FILE $BLOCK_TIME"

cd ~/ERC-4337-Bundlers-Test-Setup/client/dist && node transferUserOpRoundsThrottled.js "$ROUNDS_TOTAL" "$SCA_NUMBER" "$THROTTLE_TIME" "$BLOCK_TIME"

scp -r confirmed_blocks.csv "$MACHINE":~/ERC-4337-Bundlers-Test-Setup/powerexp/results

sleep 1

ssh "$MACHINE" \
	"sudo mv ~/ERC-4337-Bundlers-Test-Setup/powerexp/results/confirmed_blocks.csv ~/ERC-4337-Bundlers-Test-Setup/powerexp/results/sensor_output && \
	cd ~/ERC-4337-Bundlers-Test-Setup/scripts && ./native/stop_native.sh && \
	./power/powerAPI/process.sh $OUTPUT_FILE native"

#sudo cp ~/"$output_file_name-pdu.csv" ~/powerexp/results/sensor_output
