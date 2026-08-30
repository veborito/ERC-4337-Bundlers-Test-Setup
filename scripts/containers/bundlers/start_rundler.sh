#!/usr/bin/env bash

set -euo pipefail

sudo docker run --rm -d \
	--name rundler \
	-e RUST_LOG=info \
	-e SIGNER_PRIVATE_KEYS="0x47e179ec197488593b187f80a00eb0da91f1b9d0b13f8733639f19c30a34926a" \
	-e NETWORK=dev \
	-e NODE_HTTP="http://172.28.30.238:8545" \
	-e UNSAFE=true \
	-e ENABLED_ENTRY_POINTS="v0.6" \
	-e CHAIN_TRANSACTION_GAS_LIMIT=30000000 \
	-e CHAIN_MIN_MAX_PRIORITY_FEE_PER_GAS=10 \
	-e CHAIN_MIN_MAX_FEE_PER_GAS=10 \
	-e MAX_GAS_ESTIMATION_GAS=30000000 \
	-p 3000:3000 \
	rundler node
