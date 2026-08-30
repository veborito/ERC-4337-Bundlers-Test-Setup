#!/usr/bin/env bash
set -euo pipefail

OUTPUT_TAR="$1.tar.gz"
TEST="$2"

cd ~/ERC-4337-Bundlers-Test-Setup/powerexp/results/sensor_output

if [ -d swatts ]; then
	sudo rm -rf swatts
fi

sudo mkdir swatts

source ~/ERC-4337-Bundlers-Test-Setup/powerexp/venvs/smartwatts/bin/activate

sudo ~/ERC-4337-Bundlers-Test-Setup/powerexp/venvs/smartwatts/bin/python3 -m smartwatts \
	--input csv \
	--model HWPCReport \
	--files core.csv,msr.csv,rapl.csv \
	--name puller_csv --output csv \
	--model PowerReport \
	--directory "$(pwd)/swatts/" \
	--name pusher_csv \
	--cpu-base-freq 3000 \
	--cpu-tdp 155 \
	--cpu-error-threshold 2.0 \
	--sensor-reports-frequency 500

deactivate

cd ..

if [ "$TEST" = "docker" ]; then
	sudo mv container_ids.txt ./sensor_output/
fi
sudo cp config_file.json ./sensor_output/
sudo tar -czf $OUTPUT_TAR sensor_output
