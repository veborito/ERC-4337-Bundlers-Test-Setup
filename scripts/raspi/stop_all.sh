#!/usr/bin/env bash

set -euo pipefail

kill $(cat ../../powerexp/raspi/pids.txt)

sudo docker stop $(sudo docker ps -a -q)
