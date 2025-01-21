sudo pacman -Sy zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sudo pacman -Sy sof-firmware
sudo pacman -Sy brightnessctl

sudo pacman -S lua-language-server
sudo pacman -Sy npm
sudo npm install --global yarn
sudo npm install -g pyright

# uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install zsh-syntax-highlighting
brew install wget
brew install zsh-autosuggestions
sudo pacman -Sy direnv

