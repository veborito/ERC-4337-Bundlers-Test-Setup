#!/usr/bin/env bash

set -euo pipefail

while read line; do
	kill "$line"
done <~/ERC-4337-Bundlers-Test-Setup/powerexp/raspi/pids.txt

sudo docker stop $(sudo docker ps -a -q)
