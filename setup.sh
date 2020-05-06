#!/usr/bin/env bash
source $HOME/dotfiles/helper.sh

# Install yay package manager
./yay.sh

PACKAGES=(
  # Fonts
  adobe-source-han-sans-jp-fonts # Font for kanji/hiragana/katakana

  # i3 setup
  i3-gaps-rounded-git
  i3exit
  polybar # Status bar
  rofi # Fancier dmenu
  dunst # Notification daemon

  # Terminal Emulator
  kitty

  # Display Manager (Login screen)
  lightdm
  lightdm-gtk-greeter
  lightdm-gtk-greeter-settings

  # Night light
  redshift

  # GTK Theme Settings
  lxappearence

  # Syntax highlighting for ccat
  highlight

  # PDF Viewer
  evince

  # Latex stuff
  pdftk
  texlive-most
  texlive-lang # Other langauges support, accents, symbols etc.
  minted # Code syntax highlighting

  # Bluetooth
  bluez
  bluez-utils

  # Misc. utils
  light # Brightness commands
  nitrogen # Wallpaper manager
  calc # Terminal calculator
  python-dbus # Python API for dbus
  xclip # Clipboard utils
  maim # Screenshots

  # Audio Management
  pulseaudio

  # Network Management
  netctl
  wpa_supplicant
  dhcpcd
)

# Install needed packages
input "${ORANGE}Install/upgrade needed packages with yay and pip?"
if [[ $ANSWER = true ]]; then
  # Package list to space-separated string
  PACKAGES_STR=( IFS=$' '; echo "${PACKAGES[*]}" )
  yay -Syu $PACKAGES_STR

  # Needed for weather polybar script
  pip install --user bs4 html5lib 
fi

### i3-gaps
if [ -f $HOME/.config/i3/config ]; then
  # Backing up old i3 config file
  rm -rf $HOME/.config/i3/config.backup
  mv $HOME/.config/i3/config $HOME/.config/i3/config.backup
  echo -e "${ORANGE}Renamed current ${RED}~/.config/i3/config${NC} ${ORANGE}to ${GREEN}~/.config/i3/config.backup${NC}"
fi

# Symlink fonts folder
[ -d $HOME/.local/share/fonts ] || ln -s $HOME/dotfiles/fonts $HOME/.local/share

# Symlink binaries
[ -d $HOME/.bin ] || ln -s $HOME/dotfiles/.bin $HOME/

# Create i3 config dir if it doesn't exist already
mkdir -p $HOME/.config/i3

# Symlink kitty config files from git repo to configs
ln -sf $HOME/dotfiles/i3/config $HOME/.config/i3

# Symlink .profile
ln -sf $HOME/dotfiles/.profile $HOME

# Symlink dunst settings
ln -sf $HOME/dotfiles/dunst $HOME/.config

### Kitty Terminal
if [ -f $HOME/.config/kitty/kitty.conf ]; then
  # Backing up old kitty config file
  rm -rf $HOME/.config/kitty/kitty.conf.backup
  mv $HOME/.config/kitty/kitty.conf $HOME/.config/kitty/kitty.conf.backup
  echo -e "${ORANGE}Renamed current ${RED}~/.config/kitty/kitty.conf${NC} ${ORANGE}to ${GREEN}~/.config/kitty/kitty.conf.backup${NC}"
fi

# Create kitty config dir if it doesn't exist already
[ -d $HOME/.config/kitty ] || mkdir -p $HOME/.config/kitty

# Symlink kitty config files from git repo to configs
ln -sf $HOME/dotfiles/kitty/kitty.conf $HOME/.config/kitty

# Rofi config
[ -d $HOME/.config/rofi ] || ln -sf $HOME/dotfiles/rofi $HOME/.config

### Polybar
if [ -d $HOME/.config/polybar ]; then
  rm -rf $HOME/.config/polybar.backup
  mv $HOME/.config/polybar $HOME/.config/polybar.backup
  echo -e "${ORANGE}Renamed current ${RED}~/.config/polybar${NC} ${ORANGE}to ${GREEN}~/.config/polybar.backup${NC}"
fi

ln -sf $HOME/dotfiles/polybar $HOME/.config

### picom
if [ -d $HOME/.config/picom ]; then
  rm -rf $HOME/.config/picom.backup
  mv $HOME/.config/picom $HOME/.config/picom.backup
  echo -e "${ORANGE}Renamed current ${RED}~/.config/picom${NC} ${ORANGE}to ${GREEN}~/.config/picom.backup${NC}"
fi

ln -sf $HOME/dotfiles/picom $HOME/.config

# Start tlp if installed
if [ -x "$(command -v tlp)" ]; then
  sudo tlp start
fi

# Add Flathub flatpak repository if flatpak is installed
if [ -x "$(command -v flatpak)" ]; then
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

input "${ORANGE}Replace neofetch config?"
if [[ $ANSWER = true ]]; then
  NEOFETCH_PATH=$HOME/.config/neofetch/config.conf
  BACKUP_PATH=$HOME/.config/neofetch/config.conf.backup
  MESSAGE="${ORANGE}Backed up current neofetch config to '$BACKUP_PATH'${NC}"

  [ -f $NEOFETCH_PATH ] && mv $NEOFETCH_PATH $BACKUP_PATH && echo $MESSAGE

  ln -sf $HOME/dotfiles/neofetch/config.conf $HOME/.config/neofetch
fi

