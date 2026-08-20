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

## PowerJoular

Source: https://github.com/joular/powerjoular

Clone powerjoular's repository. Then run installer script in installer/bash-installer/build-install.sh

