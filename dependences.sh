#!/bin/bash
#
# Author: Max Souza, @Maaacs
# https://github.com/Maaacs/Spaceship-Dracula-Colors
#

# Checks SO 
OS=$(uname -s)
if [[ "$OS" == "Linux" ]]; then
  echo "Installating dependences on Linux..."
  #sudo add-apt-repository universe
  sudo apt update && sudo apt upgrade -y
  sudo apt-get install git
  echo "installing Fira Code..."
  fonts_dir="${HOME}/.local/share/fonts"
  if [ ! -d "${fonts_dir}" ]; then
    echo "mkdir -p $fonts_dir"
    mkdir -p "${fonts_dir}"
  else
    echo "Found fonts dir $fonts_dir"
  fi
  version=5.2
  zip=Fira_Code_v${version}.zip
  curl --fail --location --show-error https://github.com/tonsky/FiraCode/releases/download/${version}/${zip} --output ${zip}
  unzip -o -q -d ${fonts_dir} ${zip}
  rm ${zip}
  echo "fc-cache -f"
  fc-cache -f
  gsettings set org.gnome.desktop.interface monospace-font-name 'Fira Code 11'
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