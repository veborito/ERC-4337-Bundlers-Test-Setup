#!/usr/bin/env bash

set -euo pipefail

while read line; do
	kill "$line"
done < pids.txt

sudo docker stop $(sudo docker ps -a -q)

rm pids.txt
