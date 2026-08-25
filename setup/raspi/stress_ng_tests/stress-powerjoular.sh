#!/usr/bin/env bash

set -euo pipefail

if [ ! -d "./powerjoular_output" ]; then
	mkdir ./powerjoular_output
fi

cd powerjoular_output

for i in {1..4}; do
	stress-ng --cpu "$i" --timeout 180 &
	powerjoular -a stress-ng-cpu -f "powerjoular-cpu-$i" &
	powerjoular_pid="$!"
	sleep 180
	kill "$powerjoular_pid"
done

powerjoular -f "idle" &
powerjoular_pid="$!"
sleep 180
kill "$powerjoular_pid"
