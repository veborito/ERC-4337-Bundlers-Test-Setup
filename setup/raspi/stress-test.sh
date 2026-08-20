#!/usr/bin/env bash

set -euo pipefail

MAC_ADDRESS="$1"

if [ ! -d "./output" ]; then
	mkdir ./output
fi

for i in {1..4}; do
	stress-ng --cpu $i --timeout 35 &
	./powerspy.py -i 1 -d 30 -f "./output/raspi-cpu-$i.csv" $1 
	sleep 5
done

./powerspy.py -i 1 -d 30 -f ./output/raspi-idle.csv $1 

