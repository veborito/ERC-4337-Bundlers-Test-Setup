#!/usr/bin/env bash

set -euo pipefail

if [ ! -d ~/powerexp/dump ]; then
	mkdir ~/ERC-4337-Bundlers-Test-Setup/powerexp/dump
fi

output_file=$1
BLOCK_TIME=$2
ANVIL_LOG_FILE="/tmp/anvil-8545.log"
ALTO_LOG_FILE="/tmp/alto-3000.log"
# PDU_LOG_FILE="/tmp/pdu.log"

cd ~/ERC-4337-Bundlers-Test-Setup/powerexp

sudo systemd-run \
	--scope \
	--slice=user.slice \
	--unit=anvil anvil \
	--port 8545 \
	--host 0.0.0.0 \
	--chain-id 1337 \
	--block-time $BLOCK_TIME \
	--gas-limit 30000000 \
	--gas-price 1 \
	--block-base-fee-per-gas 0 \
	--disable-min-priority-fee \
	--load-state ./state/state.json \
	--dump-state ./dump/state.json \
	--disable-code-size-limit \
	--quiet \
	>"$ANVIL_LOG_FILE" 2>&1 &

sleep 1

cd ~/alto

sudo systemd-run \
	--scope \
	--slice=user.slice \
	--unit=alto ./alto run --config "alto-config.json" --port 3000 --log-level "fatal" \
	>"$ALTO_LOG_FILE" 2>&1 &

sleep 1

cd ~/ERC-4337-Bundlers-Test-Setup/powerexp/results/

if [ -d sensor_output ]; then
	sudo rm -rf sensor_output
fi

sudo mkdir sensor_output

sudo docker run \
	--rm \
	-d \
	--name hwpc-sensor \
	--net=host \
	--privileged \
	--pid=host \
	-v /sys:/sys \
	-v /var/lib/docker/containers:/var/lib/docker/containers:ro \
	-v $(pwd)/sensor_output:/hwpc_reports \
	-v $(pwd):/srv \
	-v $(pwd)/config_file.json:/config_file.json \
	powerapi/hwpc-sensor --config-file /config_file.json

#python3 -u ./pdu_power_csv.py $output_file-pdu.csv http://raclette-pdu-1.cluster.iiun.unine.ch 180 > "$PDU_LOG_FILE" 2>&1 &
