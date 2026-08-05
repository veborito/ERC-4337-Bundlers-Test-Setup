#!/usr/bin/env bash

set -euo pipefail

if (( $# != 2 )); then
  echo "Usage: $0 [MACHINE] [PROCESSOR]" >&2
  exit 1
fi

MACHINE="$1"
PROCESSOR="$2"

TEST_CONFIGS=(
    "50:100:25:12"
    "50:100:50:12"
    "50:100:100:12"
    "50:75:25:12"
    "50:50:25:12"
    "50:25:25:12"
    "100:100:25:6"
    "300:100:25:2"
)

TEST_CONFIGS=(
    "1:100:10:12"
    "1:100:10:6"
    "1:100:10:2"
)


num=1
for config in "${TEST_CONFIGS[@]}"; do
	IFS=":" read -r rounds sca throttle block_time <<< "$config"
	echo "=========================================="
	echo "Running Test #$num"
	echo "Rounds: $rounds | SCA: $sca | Throttle: $throttle | Block Time: ${block_time}s"
	echo "=========================================="
	./runDockerTest.sh "$MACHINE" "test-${num}-$PROCESSOR-docker-r${rounds}-s${sca}-t${throttle}-b${block_time}" "$rounds" "$sca" "$throttle" "$block_time"
	((num++))
	sleep 1
done

ssh "$PROCESSOR" 'cd ~/powerexp/anvil && sudo docker build --no-cache --progress=plain -t anvil-debian-slim:local -f AnvilDockerfile .'

./runIdleDockerTest.sh "$MACHINE" "$PROCESSOR"
