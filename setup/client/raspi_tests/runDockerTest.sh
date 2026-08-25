#!/usr/bin/env bash
set -euo pipefail

# change this thing with getops and parameter extension
if (( $# < 8 || $# > 9 )); then
  echo "Usage: $0 [NODE_MACHINE] [BUNDLER_MACHINE] [OUTPUT_FILE] [ROUNDS_TOTAL] [SCA_NUMBER] [THROTTLE_TIME] [BLOCK_TIME] [MAC_ADDRESS] [BUNDLER: optional]" >&2
  exit 1
fi

NODE_MACHINE="$1"
BUNDLER_MACHINE="$2"
OUTPUT_FILE="$3"

ROUNDS_TOTAL="$4"
SCA_NUMBER="$5"
THROTTLE_TIME="$6"
BLOCK_TIME="$7"
MAC_ADDRESS=$8
BUNDLER=${9:-alto}

npx tsc -p ~/client/tsconfig.json

if (($BLOCK_TIME == 6)); then
	ssh "$NODE_MACHINE" 'cd ~/powerexp/anvil && sudo docker build --no-cache --progress=plain -t anvil-debian-slim:local -f AnvilDockerfile-6 .'
fi

if (($BLOCK_TIME == 2)); then
	ssh "$NODE_MACHINE" 'cd ~/powerexp/anvil && sudo docker build --no-cache --progress=plain -t anvil-debian-slim:local -f AnvilDockerfile-2 .'
fi

ssh "$NODE_MACHINE" 'cd ~/powerexp && ./start_node_container.sh && cd results && ./measure.sh'

ssh "$BUNDLER_MACHINE" "cd ~/ERC-4337-Bundlers-Test-Setup/setup/raspi/bundlers_tests && ./start_and_measure.sh $MAC_ADDRESS raspi-$BUNDLER-r$ROUNDS_TOTAL-s$SCA_NUMBER-t$THROTTLE_TIME-b$BLOCK_TIME $BUNDLER"

echo "everything started smoothly..."

sleep 5

cd ~/client/dist && node transferUserOpRoundsThrottled.js "$ROUNDS_TOTAL" "$SCA_NUMBER" "$THROTTLE_TIME" "$BLOCK_TIME"

scp confirmed_blocks.csv "$NODE_MACHINE":~/powerexp/results/

ssh "$NODE_MACHINE" "cd ~/powerexp && sudo mv results/confirmed_blocks.csv results/sensor_output/ && ./stop_node_container.sh && cd results && ./process.sh $OUTPUT_FILE docker"

ssh "$BUNDLER_MACHINE" "cd ~/ERC-4337-Bundlers-Test-Setup/setup/raspi/bundlers_tests && ./stop_all.sh"

echo "everything stoped gracefully..."
if (($BLOCK_TIME != 12)); then
	ssh "$NODE_MACHINE" 'cd ~/powerexp/anvil && sudo docker build --no-cache --progress=plain -t anvil-debian-slim:local -f AnvilDockerfile .'
fi
