#!/usr/bin/env bash

set -euo pipefail

MAC_ADDRESS="$1"
OUTPUT_FILE="$2"
BUNDLER="$3"

if [ ! -d ~/ERC-4337-Bundlers-Test-Setup/powerexp/raspi/output ]; then
	mkdir ~/ERC-4337-Bundlers-Test-Setup/powerexp/raspi/output
fi

cd ~/ERC-4337-Bundlers-Test-Setup/scripts

if [[ "$BUNDLER" == "alto" ]]; then
	./containers/bundlers/start_alto.sh
elif [[ "$BUNDLER" == "rundler" ]]; then
	./containers/bundlers/start_rundler.sh
else
	echo "Error: this bundler is not supported."
	exit 1
fi

echo "Successfully started $BUNDLER..."

source ../powerexp/raspi/.venv/bin/activate

./power/hardware/powerspy.py -i 1 -f "../powerexp/raspi/output/powerspy-$OUTPUT_FILE.csv" "$MAC_ADDRESS" >/dev/null 2>&1 &
powerspy_pid="$!"

deactivate

if [ -f ~/ERC-4337-Bundlers-Test-Setup/powerexp/raspi/pids.txt ]; then
	rm ~/ERC-4337-Bundlers-Test-Setup/powerexp/raspi/pids.txt
fi

echo "$powerspy_pid" >> ../powerexp/raspi/pids.txt

echo "Successfully started powerspy..."

PID=$(sudo docker inspect --format '{{.State.Pid}}' "$BUNDLER")

cd ~/ERC-4337-Bundlers-Test-Setup/powerexp/raspi/output
# no need to add powerjoular PID to kill since its stop with the process its measuring...
powerjoular -p "$PID" -f "powerjoular-$OUTPUT_FILE" >/dev/null 2>&1 & 

echo "Successfully started powerjoular..."
