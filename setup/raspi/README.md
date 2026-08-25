# Raspberry Pi setup

## Dependecies

To install dependecies run the dependencies.sh script

## Powerspy

Source: https://github.com/patrickmarlier/powerspy.py

Create a python env bash```python3 -m venv .venv```
Activate env bash```source .venv/bin/activate```
Install requirements bash ```pip install -r requirements.txt```

Exmaple use:
    bash```./powerspy.py -v -i 1 -d 300 -f idle.csv  [MAC_ADDRESS]```
    bash```./powerspy.py -h #for more info on options```

## PowerJoular

Source: https://github.com/joular/powerjoular

Clone powerjoular's repository. Then run installer script in installer/bash-installer/build-install.sh

## Bundlers
For every bundler don't forget to change the endpoint of your EVM node in the config.

### Alto
To build alto's image:
go into powerexp/alto folder and build the image with bash```docker build --no-cache --progress=plain -t alto-debian-slim:local -f AltoDockerfile .```

### Rundler
To build rundler image:
- clone v0.11.0 of rundler repository:  https://github.com/alchemyplatform/rundler.git
- then run bash```docker buildx build . -t rundler```

## UserOps

On your client machine, don't forget to change the endpoints of your bundler and EVM node in transferUserOpRoundsThrottled.ts.
