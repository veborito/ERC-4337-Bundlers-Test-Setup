#!/usr/bin/env bash
set -euo pipefail

# pull sensor image
sudo docker pull ghcr.io/powerapi-ng/hwpc-sensor
sudo modprobe msr

cd ~/ERC-4337-Bundlers-Test-Setup/powerexp
mkdir -p ./venvs

python3 -m venv ./venvs/smartwatts

source ./venvs/smartwatts/bin/activate

pip install -r ./requirements.txt

deactivate
