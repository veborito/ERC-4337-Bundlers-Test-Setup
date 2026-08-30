#!/usr/bin/env bash

# powerspy dependencies
sudo apt install -y python3 python3-dev \
	software-properties-common gcc-aarch64-linux-gnu \
	bluez libbluetooth-dev \

# cpu stress testing with stress-ng
sudo apt install stress-ng 

# powerjoular dependencies
sudo apt install gnat gprbuild
