# Raspberry Pi setup

---

## Dependecies

To install dependecies run the `dependencies.sh` script

## [Powerspy](https://github.com/patrickmarlier/powerspy.py)

```bash
python3 -m venv .venv # Create a python env 
source .venv/bin/activate # Activate python env
pip install -r requirements.txt # Install requirements
deactivate
```

Exmaple use:

```bash
./powerspy.py -v -i 1 -d 300 -f idle.csv  [MAC_ADDRESS]
./powerspy.py -h # For more information
```

## [PowerJoular](https://github.com/joular/powerjoular)

Clone powerjoular's repository. Then run installer script in installer/bash-installer/build-install.sh

Example use:

```bash
powerjoular -p [PID] -f [OUTPUT_FILE]
powerjoular -h
```

## Bundlers

For most bundlers. You will need to change the endpoint of your EVM node in their config or cli arguments.

Some bundlers only support a few/all/one of the entrypoints present in the table below. This can lead to confusing errors. Make sure your node supports the correct entrypoints. This experimental setup is using anvil. It also expects entrypoint v0.6.0, SimpleAccountFactory (for entrypoint v6) and their dependencies.

| Versions | Entrypoints canonical addresses            |
|----------|--------------------------------------------|
| v0.6.0   | 0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789 |
| v0.7.0   | 0x0000000071727De22E5E9d8BAf0edAc6f37da032 |
| v0.8.0.  | 0x4337084D9E255Ff0702461CF8895CE9E3b5Ff108 |
| v0.9.0.  | 0x433709009B8330FDa32311DF1C2AFA402eD8D009 |

### Alto

To build alto's image:
Go into `setup/powerexp/alto` folder and build the image using:

```bash
docker build --no-cache --progress=plain -t alto-debian-slim:local -f AltoDockerfile .
```

If you need to change configuration details. Check `setup/powerexp/alto/alto-config.json`

### Rundler

To build rundler image:

First clone v0.11.0 rundler repository:

```bash
git clone https://github.com/alchemyplatform/rundler.git
git checkout v0.11.0
```

Then run:

```bash
docker buildx build . -t rundler
```

As explained on [rundler repository](https://github.com/alchemyplatform/rundler/blob/main/docs/architecture/entry_point.md#:~:text=etc%2E-,Rundler,chain),
>Rundler expects that the entry points are unmodified from their canonical versions.

Thus, if your entrypoint has another address it won't work :)

If your SCAs were already deployed with your previous simpleAccountFactory contract. You'll need to redeploy every SCA with the new simpleAccountFactory linked to the new entrypoint. Otherwise it won't work :D
 
>[!TIP]
>If you're facing issues with this, deploy a new EVM node from scratch it should be easier to set up.

## Deploying needed contracts (optional)

>[!WARNING]
> This should not be needed if you use the provided setup.

On your EVM node (anvil, geth,...).
The easiest way is to clone the official [account-abstraction repository](https://github.com/eth-infinitism/account-abstraction.git).

```bash
git clone https://github.com/eth-infinitism/account-abstraction.git
git checkout [version (e.g. v0.7.0)]
yarn install
yarn hardhat deploy --network dev
```

This will deploy the entrypoint and simpleAccountFactory contracts and their dependencies.

To deploy the custom TestToken. You need to create a forge project. E.g. go in the `powerexp/anvil` folder:

```bash
forge init --no-git my_project
```

Put Deploy.s.sol script into `my_project/script` folder. and the TestToken.sol into src folder.

```bash
forge build
forge script script/Deploy.s.sol --broadcast --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

And voilà.

## UserOps

On your client machine, don't forget to change the endpoints of your bundler and EVM node in transferUserOpRoundsThrottled.ts.

If you have another entrypoint address change that too. (And any other deterministic modifications)
