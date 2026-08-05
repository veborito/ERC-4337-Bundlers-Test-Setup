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

npx tsc -p ~/client/tsconfig.json

if (($BLOCK_TIME == 6)); then
	ssh "$MACHINE" 'cd ~/powerexp/anvil && sudo docker build --no-cache --progress=plain -t anvil-debian-slim:local -f AnvilDockerfile-6 .'
fi

if (($BLOCK_TIME == 2)); then
	ssh "$MACHINE" 'cd ~/powerexp/anvil && sudo docker build --no-cache --progress=plain -t anvil-debian-slim:local -f AnvilDockerfile-2 .'
fi

ssh "$MACHINE" 'cd ~/powerexp && ./start_containers.sh && cd results && ./measure.sh'
sleep 3

cd ~/client/dist && node transferUserOpRoundsThrottled.js "$ROUNDS_TOTAL" "$SCA_NUMBER" "$THROTTLE_TIME" "$BLOCK_TIME"

scp confirmed_blocks.csv "$MACHINE":~/powerexp/results/

ssh "$MACHINE" "cd ~/powerexp && sudo mv results/confirmed_blocks.csv results/sensor_output/ && ./stop_containers.sh && cd results && ./process.sh $OUTPUT_FILE docker"
