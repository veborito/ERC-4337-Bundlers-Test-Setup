#!/usr/bin/env bash
set -euo pipefail

# change this thing with getops and parameter extension
if (($# < 8 || $# > 9)); then
	echo "Usage: $0 [NODE_MACHINE] [BUNDLER_MACHINE] [OUTPUT_FILE] [ROUNDS_TOTAL] [SCA_NUMBER] [THROTTLE_TIME] [BLOCK_TIME] [MAC_ADDRESS] [BUNDLER: optional]" >&2
	exit 1
fi

# Example usage:
#   ./runRaspiTests.sh 172.28.30.238 172.28.11.252 test 20 10 10 12 00:08:99:4D:F8:F0 rundler

NODE_MACHINE="$1"
BUNDLER_MACHINE="$2"
OUTPUT_FILE="$3"

ROUNDS_TOTAL="$4"
SCA_NUMBER="$5"
THROTTLE_TIME="$6"
BLOCK_TIME="$7"
MAC_ADDRESS=$8
BUNDLER=${9:-alto}

cd ~/ERC-4337-Bundlers-Test-Setup/client/
npx tsc -p ./tsconfig.json

if (($BLOCK_TIME == 6)); then
	ssh "$NODE_MACHINE" 'cd ~/ERC-4337-Bundlers-Test-Setup/powerexp/anvil && sudo docker build --no-cache --progress=plain -t anvil-debian-slim:local -f AnvilDockerfile-6 .'
fi

if (($BLOCK_TIME == 2)); then
	ssh "$NODE_MACHINE" 'cd ~/ERC-4337-Bundlers-Test-Setup/powerexp/anvil && sudo docker build --no-cache --progress=plain -t anvil-debian-slim:local -f AnvilDockerfile-2 .'
fi

ssh "$NODE_MACHINE" 'cd ~/ERC-4337-Bundlers-Test-Setup/scripts/containers && ./start_node_container.sh && cd ~/ERC-4337-Bundlers-Test-Setup/scripts/power/powerAPI && ./measure.sh'

ssh "$BUNDLER_MACHINE" "cd ~/ERC-4337-Bundlers-Test-Setup/scripts/raspi && ./start_and_measure.sh $MAC_ADDRESS raspi-$BUNDLER-r$ROUNDS_TOTAL-s$SCA_NUMBER-t$THROTTLE_TIME-b$BLOCK_TIME $BUNDLER"

echo "everything started smoothly..."

sleep 5

cd ~/client/dist && node transferUserOpRoundsThrottled.js "$ROUNDS_TOTAL" "$SCA_NUMBER" "$THROTTLE_TIME" "$BLOCK_TIME"

scp confirmed_blocks.csv "$NODE_MACHINE":~/ERC-4337-Bundlers-Test-Setup/powerexp/results/

ssh "$NODE_MACHINE" "cd ~/ERC-4337-Bundlers-Test-Setup/powerexp && sudo mv results/confirmed_blocks.csv results/sensor_output/ && cd ~/ERC-4337-Bundlers-Test-Setup/scripts && ./containers/stop_containers.sh && ./power/powerAPI/process.sh $OUTPUT_FILE raspi"

ssh "$BUNDLER_MACHINE" "cd ~/ERC-4337-Bundlers-Test-Setup/scripts/raspi && ./stop_all.sh"

echo "everything stoped gracefully..."
if (($BLOCK_TIME != 12)); then
	ssh "$NODE_MACHINE" 'cd ~/ERC-4337-Bundlers-Test-Setup/powerexp/anvil && sudo docker build --no-cache --progress=plain -t anvil-debian-slim:local -f AnvilDockerfile .'
fi
