#!/bin/bash
#
# Author: Max Souza, @Maaacs
# https://github.com/Maaacs/Spaceship-Dracula-Colors
#

# Checks SO 
OS=$(uname -s)
if [[ "$OS" == "Linux" ]]; then
  echo "Installating dependences on Linux..."
  sudo add-apt-repository universe
  sudo apt update && sudo apt upgrade -y
  sudo apt-get install git-all
  sudo apt install fonts-firacode
  echo "Finish install dependences on Linux."
  sudo apt-get install dconf-cli
  git clone https://github.com/dracula/gnome-terminal
  ./gnome-terminal/install.sh
  echo "Installing ohmyzsh"
  sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
  echo "Finish ohmyzsh install"
elif [[ "$OS" == "Darwin" ]]; then
  echo "Start installation on MacOS X."
  echo "Installing ohmyzsh"
  sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
  echo "Finish ohmyzsh install"
  # Verify brew installation
  if ! brew --version > /dev/null 2>&1; then
    echo "Brew not found. Installing brew...!"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || { echo "Failed to install Brew."; exit 1; }
  fi
  # Brew is guaranteed to be installed
  if ! brew list gnu-sed > /dev/null 2>&1; then
    brew install gnu-sed
  fi
  # Check and append to .zshrc only once
  if [[ -f ~/.zshrc && -w ~/.zshrc && ! $(grep 'GNUD-SED' ~/.zshrc) ]]; then
    echo '
#START GNUD-SED
PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
#END GNUD-SED
' >> ~/.zshrc
    echo "Gnu-sed installed and configured."
  else
    echo "Gnu-sed already installed or .zshrc not found/not writable."
  fi
else
  echo "Unsupported operating system."
fi