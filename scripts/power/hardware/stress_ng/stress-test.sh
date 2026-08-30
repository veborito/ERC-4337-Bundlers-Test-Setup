#!/usr/bin/env bash

set -euo pipefail

MAC_ADDRESS="$1"

if [ ! -d ~/powerexp/raspi/output ]; then
	mkdir ~/powerexp/raspi/output
fi

for i in {1..4}; do
	stress-ng --cpu "$i" --timeout 180 &
	./powerspy.py -i 1 -d 180 -f ~/powerexp/raspi/output/raspi-cpu-"$i".csv "$MAC_ADDRESS"
	sleep 5
done

./powerspy.py -i 1 -d 180 -f ~/powerexp/raspi/output/raspi-idle.csv "$MAC_ADDRESS"
