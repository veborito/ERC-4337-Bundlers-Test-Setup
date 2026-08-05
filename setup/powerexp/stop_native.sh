#!/usr/bin/env bash
set -euo pipefail

sudo systemctl stop anvil.scope
echo "Anvil stopped"

sudo systemctl stop alto.scope
echo "Alto stopped"

sudo docker stop hwpc-sensor
echo "HWPC stopped"
