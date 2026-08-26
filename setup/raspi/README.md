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

#### relationship between entrypoints and rundler
As explined on [rundler repository](https://github.com/alchemyplatform/rundler/blob/main/docs/architecture/entry_point.md#:~:text=etc%2E-,Rundler,chain), "Rundler expects that the entry points are unmodified from their canonical versions."
This means that you need your entrypoint to be deployed on the following addresses for each versions:
    - v0.6.0: 0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789
    - v0.7.0: 0x0000000071727De22E5E9d8BAf0edAc6f37da032
    - v0.8.0: 0x4337084D9E255Ff0702461CF8895CE9E3b5Ff108
    - v0.9.0: 0x433709009B8330FDa32311DF1C2AFA402eD8D009

If your entrypoint has another address it won't work :)

If your SCAs were already deployed with your previous simpleAccountFactory contract that was linked to your previous entrypoint.
You need to redeploy every SCA with the new simpleAccountFactory linked to the new entrypoint. Otherwise it won't work :D
(if you face this issue, start a new node from scratch it should be easier at least on anvil).

My testing setup using anvil expect entrypoint v0.6.0

## deploying needed contracts

Important note: this should not be needed if you use the provided setup.

On your EVM node (anvil, geth,...).
Easiest way is to clone the official [account-abstraction repository](https://github.com/eth-infinitism/account-abstraction.git).
Then:
bash```
git checkout [version (e.g. v0.7.0)]
yarn install
yarn hardhat deploy --network dev
```

This will deploy the entrypoint and simpleAccountFactory contracts and their dependencies.

To deploy the custom TestToken. You need to create a forge project. In the powerexp/anvil folder:

bash```
forge init --no-git my_project
```
Put Deploy.s.sol script into the script folder. and the TestToken.sol into src folder.

bash```
forge build
forge script script/Deploy.s.sol --broadcast --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```
And voilà. 

## UserOps

On your client machine, don't forget to change the endpoints of your bundler and EVM node in transferUserOpRoundsThrottled.ts.
If you have another entrypoint address change that too. (And any other deterministic modifications)
