#!/usr/bin/env bash

set -euo pipefail

if (( $# != 2 )); then
  echo "Usage: $0 [MACHINE] [PROCESSOR]" >&2
  exit 1
fi

MACHINE="$1"
PROCESSOR="$2"

ssh "$MACHINE" 'cd ~/powerexp && ./start_containers.sh && cd results && ./measure.sh'

#sleep 500
sleep 10

ssh "$MACHINE" "cd ~/powerexp && ./stop_containers.sh && cd results && ./process.sh test-9-idle-$PROCESSOR-docker docker"
