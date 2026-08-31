#!/usr/bin/env bash

set -euo pipefail

if [ -f ~/ERC-4337-Bundlers-Test-Setup/powerexp/raspi/pids.txt ]; then
	kill $(cat ../../powerexp/raspi/pids.txt)
fi

sudo docker stop $(sudo docker ps -a -q)
