#!/usr/bin/env bash
source $HOME/dotfiles/helper.sh

read -p "${ORANGE}Do you want to install ${GREEN}apt packages${ORANGE}? (Y/n)${NC} " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]] ; then
 cd $HOME/dotfiles
  chmod +x apt_packages.sh
  ./apt_packages.sh
fi

# Start tlp if installed
if [ -x "$(command -v tlp)" ] ; then
  sudo tlp start
fi

# Add Flathub flatpak repository if flatpak is installed
if [ -x "$(command -v flatpak)" ] ; then
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

# Installing Yarn
echo
read -p "${ORANGE}Do you want to install ${GREEN}Yarn${ORANGE}? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
	sudo apt update && sudo apt install yarn
fi

# Installing pyenv
echo
read -p "${ORANGE}Do you want to install ${GREEN}pyenv${ORANGE}? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
  sudo apt -qq install -y curl
  curl https://pyenv.run | bash
fi

# Installing poetry
read -p "${ORANGE}Do you want to install ${GREEN}poetry${ORANGE}? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
  sudo apt -qq install -y curl
  curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python3
fi

# Neovim: https://neovim.io
read -p "${ORANGE}Do you want to install and setup ${GREEN}Neovim 0.4.3${ORANGE}? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
    cd $HOME/dotfiles
    chmod +x nvim_setup.sh
    ./nvim_setup.sh
fi

# Nordic gtk Theme: https://github.com/EliverLara/Nordic
read -p $"${ORANGE}Do you wish to ${GREEN}install all Gnome Themes?${ORANGE}? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
   # Set close/minimize/maximize buttons to the left
  gsettings set  org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'

  ./gtk_themes.sh
fi

read -p "${ORANGE}Do you wish the install the ${GREEN}Plank dock${ORANGE}? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
  sudo apt -qq install -y plank
  read -p "${ORANGE}Do you wish to install the paperterial theme for the plank dock? (It has to be turned on manually) (Y/n)${NC} " -n 1 -r 
  echo

  if [[ $REPLY =~ ^[Yy]$ ]] ; then
    [ ! -d $HOME/.local/share/plank/themes/paperterial ] && mkdir -p $HOME/.local/share/plank/themes/paperterial

    wget -O $HOME/.local/share/plank/themes/paperterial/dock.theme "https://raw.githubusercontent.com/KenHarkey/plank-themes/master/paperterial/dock.theme"
  fi

  read -p "${ORANGE}Do you wish to replace the Gnome Dock with the Plank dock? (Y/n)${NC} " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]] ; then
    echo -e "${GREEN}Setting plank to load on start up...${NC}"

    [ ! -d $HOME/.config/autostart ] && mkdir -p $HOME/.config/autostart

    cd $HOME/dotfiles
    cp plank.desktop $HOME/.config/autostart/
    
    # Start plank
    nohup plank &

    echo -e "${GREEN}Disabling Gnome Dock...${NC}"
    gsettings set org.gnome.shell.extensions.dash-to-dock autohide false
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
    gsettings set org.gnome.shell.extensions.dash-to-dock intellihide false
  fi
fi

read -p "${ORANGE}Do you want to replace your current dotfiles with the new ones? (.aliases and .zshrc) Backups will be made (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
  cd $HOME/dotfiles
  if [ ! -x "$(command -v zsh)" ]; then
    chmod +x install-zsh.sh && ./install-zsh.sh
    echo "${RED}Re-run this script after you've done so${NC}"
    exit 0
  fi

  chmod +x install-oh-my-zsh.sh && ./install-oh-my-zsh.sh

  echo
  echo -e "${ORANGE}Backing up current dotfiles...${NC}"

  if [ -f $HOME/.zshrc ] ; then
    mv $HOME/.zshrc $HOME/.zshrc.backup # Backing up current .zshrc file
    echo -e "${ORANGE}Renamed current ${RED}~/.zshrc${NC} ${ORANGE}to ${GREEN}~/.zshrc.backup${NC}"
  fi

  if [ -f $HOME/.aliases ] ; then
    mv $HOME/.aliases $HOME/.aliases.backup # Backing up current .aliases files
    echo -e "${ORANGE}Renamed current ${RED}~/.aliases${NC} ${ORANGE}to ${GREEN}~/.aliases.backup${NC}"
  fi

  echo -e "${ORANGE}Symlinking dotfiles...${NC}"
  ln -sf $HOME/dotfiles/.zshrc $HOME
  ln -sf $HOME/dotfiles/.aliases $HOME

  source $HOME/.zshrc

  echo
  echo "${GREEN}Finished symlinking dotfiles.${NC}"
  echo
fi

read -p "${ORANGE}Do you wish to change the Desktop and Lock Wallpaper to the Kali Linux image? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
  URI="file:///${HOME}/dotfiles/images/kali-linux-wallpaper.png"
  gsettings set org.gnome.desktop.background picture-uri $URI
  gsettings set org.gnome.desktop.screensaver picture-uri $URI
fi

chmod +x chrome.sh && ./chrome.sh
chmod +x sublime.sh && ./sublime.sh
chmod +x vscode.sh && ./vscode.sh
