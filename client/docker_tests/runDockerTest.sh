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

if (($BLOCK_TIME == 6)); then
	ssh "$MACHINE" 'cd ~/ERC-4337-Bundlers-Test-Setup/powerexp/anvil && sudo docker build --no-cache --progress=plain -t anvil-debian-slim:local -f AnvilDockerfile-6 .'
fi

if (($BLOCK_TIME == 2)); then
	ssh "$MACHINE" 'cd ~/ERC-4337-Bundlers-Test-Setup/powerexp/anvil && sudo docker build --no-cache --progress=plain -t anvil-debian-slim:local -f AnvilDockerfile-2 .'
fi

ssh "$MACHINE" 'cd ~/ERC-4337-Bundlers-Test-Setup/scripts && ./containers/start_containers.sh && ./power/powerAPI/measure.sh'
sleep 3

cd ~/client/dist && node transferUserOpRoundsThrottled.js "$ROUNDS_TOTAL" "$SCA_NUMBER" "$THROTTLE_TIME" "$BLOCK_TIME"

scp confirmed_blocks.csv "$MACHINE":~/ERC-4337-Bundlers-Test-Setup/powerexp/results/

ssh "$MACHINE" "cd ~/ERC-4337-Bundlers-Test-Setup/powerexp && sudo mv results/confirmed_blocks.csv results/sensor_output/ && cd ~/ERC-4337-Bundlers-Test-Setup/scripts && ./containers/stop_containers.sh && ./power/powerAPI/process.sh $OUTPUT_FILE docker"
