set -euo pipefail

OUT_FILE="${1:-containers_id.txt}"

# Optional cleanup if old containers with the same names exist
sudo docker rm -f anvil >/dev/null 2>&1 || true

ANVIL_ID=$(
  sudo docker run --rm -d \
    --name anvil \
    --network aa-exp \
    -v ~/powerexp/state/state.json:/var/lib/anvil/state.json \
    -v ~/powerexp/dump/state.json:/var/lib/anvil/dump/state.json \
    -p 8545:8545 \
    anvil-debian-slim:local 
)

{
  echo "timestamp=$(date --iso-8601=seconds)"
  echo "anvil=$ANVIL_ID"
  echo
  echo "anvil_cgroup=$(cat /proc/$(sudo docker inspect -f '{{.State.Pid}}' anvil)/cgroup | cut -d: -f3)"
} > "$OUT_FILE"

echo "Started container:"
echo "  anvil: $ANVIL_ID"
echo "Wrote ID to: $OUT_FILE"

mv $OUT_FILE ./results/
