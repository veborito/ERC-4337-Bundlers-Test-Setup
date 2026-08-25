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

cd .. && source .venv/bin/activate

./powerspy.py -i 1 -f "./bundlers_tests/output/powerspy-$OUTPUT_FILE.csv" "$MAC_ADDRESS" &
powerspy_pid="$!" 
echo "$powerspy_pid" >> pids.txt
deactivate && cd bundlers_tests

powerjoular -a $BUNDLER -f "powerjoular-$BUNDLER-$OUTPUT_FILE" &
powerjoular_pid="$!" 
echo "$powerjoular_pid" >> pids.txt

