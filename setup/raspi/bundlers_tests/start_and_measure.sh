#!/usr/bin/env bash

set -euo pipefail

MAC_ADDRESS="$1"
OUTPUT_FILE="$2"
BUNDLER="$3"

if [ ! -d "./output" ]; then
	mkdir ./output
fi

if [[ "$BUNDLER" == "alto" ]]; then
	./start_alto.sh
elif [[ "$BUNDLER" == "rundler" ]]; then
	./start_rundler.sh
else
	echo "Error: this bundler is not supported."
	exit 1
fi

echo "Successfully started $BUNDLER..."

cd .. && source .venv/bin/activate

./powerspy.py -i 1 -f "./bundlers_tests/output/powerspy-$OUTPUT_FILE.csv" "$MAC_ADDRESS" > /dev/null 2>&1 &
powerspy_pid="$!" 
deactivate && cd bundlers_tests
echo "$powerspy_pid" >> pids.txt

echo "Successfully started powerspy..."

PID=$(sudo docker inspect --format '{{.State.Pid}}' "$BUNDLER")

cd output
powerjoular -p "$PID" -f "powerjoular-$OUTPUT_FILE" > /dev/null 2>&1 &
powerjoular_pid="$!" 
echo "$powerjoular_pid" >> ../pids.txt

echo "Successfully started powerjoular..."

