#!/usr/bin/env bash

set -euo pipefail

sudo docker run --rm -d \
	--name alto \
	-p 3000:3000 \
	alto-debian-slim:local
