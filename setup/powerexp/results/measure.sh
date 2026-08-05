#!/usr/bin/env bash
set -euo pipefail

if [ -d sensor_output ]; then
  sudo rm -rf sensor_output 
fi

sudo mkdir sensor_output
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
