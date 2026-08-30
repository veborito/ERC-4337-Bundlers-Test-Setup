# ERC-4337-Bundlers-Test-Setup

---

Base repository : <https://github.com/eonica/FastTrack-ERC-4337-Experimental-Bundler-Deployment>

This repository adds explanations on the Rasberry Pi power consumption measurement setup.
For this experimental setup we used PowerJoular and PowerSpy.

## Setup Guidelines

First, install docker were needed (EVM node and Raspberry Pi. You'll find under `scripts/utils/docker-install.sh` the script for a clean installation.

Second, setup the client install package.json project dependencies.

Then setup your node (EVM alone or with bundler) particularly you will need to install PowerAPI dependencies.

More details on the native execution [dependencies](./docs/Dependencies-native-setup) in the docs.

### Client

In your client machine. Go into the `client` folder and run `npm install`

### EVM node

First run the `scripts/power/powerAPI/smartwatts-setup.sh` script to pull the `hwpc-sensor` image and install smartwatts requirements.

Build your EVM client. In this setup we use Anvil. Go into `powerexp/anvil/` and run `docker build --no-cache --progress=plain -t anvil-debian-slim:local -f AnvilDockerfile .`

---

### [Raspberry Pi setup](./docs/Raspberry-pi-setup.md#raspberry-pi-setup)

Check the [docs](./docs/Raspberry-pi-setup.md#raspberry-pi-setup) on raspberry pi for the guidelines and requirements.

---

## Testing

Once everything is setup

For more informations on the single node setup (EVM + bundler) refer to [this experimental setup](https://github.com/eonica/FastTrack-ERC-4337-Experimental-Bundler-Deployment).
