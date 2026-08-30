#!/usr/bin/env bash
set -euo pipefail

if [ -d ~/ERC-4337-Bundlers-Test-Setup/powerexp/results/sensor_output ]; then
	sudo rm -rf ~/ERC-4337-Bundlers-Test-Setup/powerexp/results/sensor_output
fi

sudo mkdir ~/ERC-4337-Bundlers-Test-Setup/powerexp/results/sensor_output

cd ~/ERC-4337-Bundlers-Test-Setup/powerexp/results/

sudo docker run --rm -d \
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
