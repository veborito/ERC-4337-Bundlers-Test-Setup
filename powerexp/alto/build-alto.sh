#!/usr/bin/env bash

set -euo pipefail

git clone https://github.com/pimlicolabs/alto

cd alto

git checkout v1.2.8
git submodule update --init --recursive

cp ../Dockerfile Dockerfile
cp ../alto-config.json . 

sudo docker buildx build --no-cache --progress=plain -t alto-debian-slim:local -f Dockerfile .

cd ..

rm -rf alto
