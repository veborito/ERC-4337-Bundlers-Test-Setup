#!/usr/bin/env bash

set -euo pipefail

if [ ! -d ~/powerexp/raspi/powerjoular_output_k ]; then
	mkdir ~/powerexp/raspi/powerjoular_output_k
fi

cd ~/powerexp/raspi/powerjoular_output_k

for i in {1..4}; do
	stress-ng --cpu "$i" --timeout 180 &
	powerjoular -k -a stress-ng-cpu -f "powerjoular-cpu-$i-k" &
	powerjoular_pid="$!"
	sleep 185
	kill "$powerjoular_pid"
done

powerjoular -f "idle_k" &
powerjoular_pid="$!"
sleep 182
kill "$powerjoular_pid"
