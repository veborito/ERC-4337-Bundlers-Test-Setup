#!/usr/bin/env bash

set -euo pipefail

if [ ! -d ~/ERC-4337-Bundlers-Test-Setup/powerexp/dump ]; then
	sudo mkdir ~/ERC-4337-Bundlers-Test-Setup/powerexp/dump
fi

OUT_FILE="${1:-container_ids.txt}"

# Optional cleanup if old containers with the same names exist
sudo docker rm -f anvil >/dev/null 2>&1 || true

cd ~/ERC-4337-Bundlers-Test-Setup/powerexp/

ANVIL_ID=$(
	sudo docker run --rm -d \
		--name anvil \
		-v $(pwd)/state/state.json:/var/lib/anvil/state.json \
		-v $(pwd)/dump/state.json:/var/lib/anvil/dump/state.json \
		-p 8545:8545 \
		anvil-debian-slim:local
)

{
	echo "timestamp=$(date --iso-8601=seconds)"
	echo "anvil=$ANVIL_ID"
	echo
	echo "anvil_cgroup=$(cat /proc/$(sudo docker inspect -f '{{.State.Pid}}' anvil)/cgroup | cut -d: -f3)"
} >"$OUT_FILE"

echo "Started container:"
echo "  anvil: $ANVIL_ID"
echo "Wrote ID to: $OUT_FILE"

mv "$OUT_FILE" ~/ERC-4337-Bundlers-Test-Setup/powerexp/results/
