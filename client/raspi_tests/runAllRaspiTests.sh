#!/usr/bin/env bash

set -euo pipefail

if (( $# != 4 && $# != 5 )); then
  echo "Usage: $0 [MACHINE] [BUNDLER_MACHINE] [BUNDLER] [POWER_TOOL] [MAC_ADDRESS: only with powerspy]" >&2
  exit 1
fi

MACHINE="$1"
BUNDLER_MACHINE="$2"
BUNDLER=$3
POWER_TOOL="$4"
MAC_ADDRESS=${5:-none}

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

##TEST_CONFIGS=(
#    "1:100:10:12"
#    "1:100:10:6"
#    "1:100:10:2"
#)

num=1
for config in "${TEST_CONFIGS[@]}"; do
	IFS=":" read -r rounds sca throttle block_time <<< "$config"
	echo "=========================================="
	echo "Running Test #$num"
	echo "Rounds: $rounds | SCA: $sca | Throttle: $throttle | Block Time: ${block_time}s"
	echo "=========================================="
	./runRaspiTest.sh "$MACHINE" "$BUNDLER_MACHINE" "test-${num}-raspi-$BUNDLER-r${rounds}-s${sca}-t${throttle}-b${block_time}" "$rounds" "$sca" "$throttle" "$block_time" "$MAC_ADDRESS" "$BUNDLER" "$POWER_TOOL"
	((num++))
	sleep 1
done

./runIdleRaspiTest.sh "$MACHINE" "$BUNDLER_MACHINE" "$MAC_ADDRESS" "$BUNDLER" "$POWER_TOOL"
