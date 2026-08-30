#!/usr/bin/env bash
set -euo pipefail

sudo docker stop "$(sudo docker ps -a -q)" #stops all containers
