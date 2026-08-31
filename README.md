# ERC-4337-Bundlers-Test-Setup

---

Base repository : <https://github.com/eonica/FastTrack-ERC-4337-Experimental-Bundler-Deployment>

This repository adds explanations on the Raspberry Pi power consumption measurement setup.
For this experimental setup we used [PowerJoular](https://github.com/joular/powerjoular) and [PowerSpy](https://github.com/patrickmarlier/powerspy.py).

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

### Raspberry Pi setup

Check the [docs](./docs/Raspberry-pi-setup.md#raspberry-pi-setup) on raspberry pi for the guidelines and requirements.

---

You final setup

[dessin du setup]

## Testing

Once everything is setup

In `client/raspi_tests` on your client machine, you will find all the tests scripts needed to reproduce the experiment.

You can run single tests with:

```bash
./runRaspiTests.sh evm_node bundler_node powerspy_mac_address output_file 20 10 10 12 00:08:99:4D:F8:F0 rundler powerspy

./runRaspiTests.sh evm_node bundler_node output_file 20 10 10 12 alto powerjoular
```

To run a batch of tests:

```bash
./runAllRaspiTests.sh evm_node bundler_node powerspy_mac_address bundler powerspy
./runAllRaspiTests.sh evm_node bundler_node bundler powerjoular # mac_address_not_needed
```
