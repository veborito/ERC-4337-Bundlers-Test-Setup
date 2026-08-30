# Dependencies for native execution

```bash
# Download and install nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.6/install.sh | bash

# in lieu of restarting the shell
\. "$HOME/.nvm/nvm.sh"

# Download and install Node.js:
nvm install 24

# Verify the Node.js version:
node -v # Should print "v24.18.0".

# Verify npm version:
npm -v # Should print "11.16.0".


# install pnpm
curl -fsSL https://get.pnpm.io/install.sh | sh -

source ~/.bashrc

# install foundry
curl -L https://getfoundry.sh/install | bash

export PATH="$PATH:$HOME/.foundry/bin"

foundryup

# install alto
git clone https://github.com/pimlicolabs/alto.git

cd alto
pnpm install
pnpm build:contracts
pnpm build

cd ~/

cp ~/powerexp/alto/alto-config.json alto/

# setup powerAPI
docker pull ghcr.io/powerapi-ng/hwpc-sensor

python3 -m venv ~/powerexp/results/venvs/smartwatts
source ~/powerexp/results/venvs/smartwatts/bin/activate

pip install smartwatts
pip install "powerapi[hwpc,csv]"

deactivate

sudo modprobe msr
```

>[!NOTE]
This is not in a script, because some issues depending on cpu arch could arise and need to be addressed independently.
