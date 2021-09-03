#/env/bash

sudo apt-get install fish

fish
sudo apt-get install yarn
sudo apt-get install git
sudo apt-get install neovim

mv config/fish/* .config/fish/
mv config/.git .config
mv config/nvim/* .config/nvim/

rm -rf config
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts && curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf

mkdir -p ~/Documents/unito/bin
touch ~/Documents/unito/unitolocal
touch ~/Documents/unito/unitostaging
touch ~/Documents/unito/unitoprod

# AWS
mkdir ~/.aws/
touch ~/.aws/credentials
touch ~/.aws/config

sudo apt-get install awscli
sudo apt-get install jq
sudo apt-get install perl

cd ~/Documents/unito/

git clone git@github.com:unitoio/connectors.git
git clone git@github.com:unitoio/console.git
git clone git@github.com:unitoio/internal-tools.git
git clone git@github.com:unitoio/sync-worker.git
