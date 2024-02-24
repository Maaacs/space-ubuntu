#!/bin/bash
#
# Author: Max Souza, @Maaacs
# https://github.com/Maaacs/Spaceship-Dracula-Colors
#

# Checks SO to GNUD-SED
OS=$(uname -s)
if [[ "$OS" == "Linux" ]]; then
  echo "Installating dependences on Linux..."
  #sudo rm /var/lib/dpkg/info/format
  #sudo printf "1\n" > /var/lib/dpkg/info/format
  sudo add-apt-repository universe
  sudo apt update && sudo apt upgrade -y
  sudo apt install zsh
  chsh -s $(which zsh)
  sudo apt-get install git-all
  sudo apt install fonts-firacode
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  echo "Finish install dependences on Linux."
elif [[ "$OS" == "Darwin" ]]; then
  echo "Start installation on MacOS X."
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

# Checks if the file ~/.zshrc exists and is accessible
if [[ -f ~/.zshrc && -w ~/.zshrc ]]; then
    echo "Starting Spaceship installation..."
    # Removing old installations
    rm -rf "$HOME/.oh-my-zsh/custom/themes/spaceship-prompt"
    rm -rf "$HOME/.oh-my-zsh/custom/themes/spaceship.zsh-theme"
    # Remove the installation of this profile before inserting a new one at the end of the file
    sed -i '/#START SPACESHIP DRACULA PROFILE/,/#END SPACESHIP DRACULA PROFILE/d' ~/.zshrc
    git clone https://github.com/Maaacs/Spaceship-Dracula-Colors.git "$HOME/.oh-my-zsh/custom/themes/spaceship-prompt" --depth=1
    # Symbolic link to spaceship theme file
    ln -s "$HOME/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/spaceship.zsh-theme"
    # Replace the current ZSH_THEME with spaceship
    sed -i 's/ZSH_THEME="[^"]*"/ZSH_THEME="spaceship"/' ~/.zshrc
    echo "Spaceship installed."
    # Insert Dracula Colors and Custom Profile
echo '
#START SPACESHIP DRACULA PROFILE
#SPACESHIP_CHAR_SYMBOL="➜"
#SPACESHIP_CHAR_SYMBOL="❯"
#SPACESHIP_USER_PREFIX="in "
SPACESHIP_USER_SHOW=always
SPACESHIP_USER_COLOR="magenta"
#SPACESHIP_DIR_PREFIX="on "
SPACESHIP_DIR_COLOR="blue"
#SPACESHIP_GIT_PREFIX=""
SPACESHIP_GIT_BRANCH_COLOR="cyan"
SPACESHIP_GIT_STATUS_COLOR="#a0e801"
SPACESHIP_PROMPT_PREFIXES_SHOW=false
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_PROMPT_SEPARATE_LINE=false
SPACESHIP_PROMPT_ORDER=(
    time          # Time stampts section
    char          # Prompt character
    user          # Username section
    dir           # Current directory section
    host          # Hostname section
    git           # Git section (git_branch + git_status)
    hg            # Mercurial section (hg_branch  + hg_status)
    gradle        # Gradle section
    maven         # Maven section
    package       # Package version
    node          # Node.js section
    ruby          # Ruby section
    elm           # Elm section
    elixir        # Elixir section
    xcode         # Xcode section
    swift         # Swift section
    golang        # Go section
    php           # PHP section
    rust          # Rust section
    haskell       # Haskell Stack section
    julia         # Julia section
    docker        # Docker section
    aws           # Amazon Web Services section
    gcloud        # Google Cloud Platform section
    venv          # virtualenv section
    conda         # conda virtualenv section
    pyenv         # Pyenv section
    dotnet        # .NET section
    ember         # Ember.js section
    kubectl       # Kubectl context section
    terraform     # Terraform workspace section
    ibmcloud      # IBM Cloud section
    exec_time     # Execution time
    line_sep      # Line break
    battery       # Battery level and status
    vi_mode       # Vi-mode indicator
    jobs          # Background jobs indicator
    exit_code     # Exit code section
    char          # Prompt character
)
#END SPACESHIP DRACULA PROFILE
' >> ~/.zshrc
    echo "Dracula theme installed."
else
    echo "The theme installation could not proceed. Verify oh-my-zsh installation."
fi

if [[ -f ~/.zshrc && -w ~/.zshrc ]]; then
    echo '#START HIGHLIGHTING AUTOSUGGESTIONS COMPLETIONS' >> ~/.zshrc
    bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
echo '
zinit light zdharma/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
#END HIGHLIGHTING AUTOSUGGESTIONS COMPLETIONS
' >> ~/.zshrc
    echo "syntax-highlighting autosuggestions completions installed."
    echo "Success! Restart Terminal..."
else
    echo "Error in Zinit."
fi