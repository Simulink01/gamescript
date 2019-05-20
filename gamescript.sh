#!/bin/bash
# https://github.com/Simulink01/gamescript/
# Copyright (c) 2019 Simulink. Released under the GNU General Public License v3.0. (https://www.gnu.org/licenses/gpl-3.0.en.html)

# Detect Debian users running the script with "sh" instead of bash
if readlink /proc/$$/exe | grep -q "dash"; then
	echo "This script needs to be run with bash, not sh"
	exit
fi

# Make sure script is running as root
if [ "$EUID" -ne 0 ]; then
 echo "Sorry, you need to run script this as root."
 exit
fi

# Confimation function
prompt_confirm() {
  while true; do
    read -r -n 1 -p "${1:-Continue?} [y/n]: " REPLY
    case $REPLY in
      [yY]) echo ; return 0 ;;
      [nN]) echo ; return 1 ;;
      *) printf " \033[31m %s \n\033[0m" "invalid input"
    esac
  done
}

# Get linux distro name
DISTRO=$( cat /etc/*-release | tr [:upper:] [:lower:] | grep -Poi '(debian|ubuntu|red hat|centos|arch)' | uniq )
if [ -z $DISTRO ]; then
    DISTRO='unknown'
fi
echo "Detected Distro: $DISTRO"
# See if compatible
if [ $DISTRO == 'ubuntu' -o 'arch' ]; then
	echo "✔️ Your distro is compatible with this script!"
else
	echo "❌ Unfortunately, your distro is NOT compatible with this script."
	echo "If you would like to see this script work with your distro you can help by contributing."
	exit
fi

# Install for ubuntu
if [ $DISTRO == 'ubuntu' ]; then
	if ! [ -x "$(command -v nvidia-smi)" ] && [ ./lspci | grep VGA | grep -q 'NVIDIA Corporation' ]
	then
   echo 'Your system reports that you do not have the propriety driver for your NVIDIA graphics card.'
	 echo 'You need a propriety driver to game because it offers better performance than open-source drivers'
	 echo 'would you like to continue with installation?'
	 prompt_confirm "" || exit 0
	 apt install nvidia-driver-390
  fi
	wget -nc https://dl.winehq.org/wine-builds/winehq.key
	apt-key add winehq.key
	apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ disco main' -y
	add-apt-repository ppa:lutris-team/lutris -y
	apt-get update
	apt-get --yes install lutris libsystemd-dev pkg-config ninja-build git winehq-staging libgnutls30:i386 libldap-2.4-2:i386 libgpg-error0:i386 libxml2:i386 libasound2-plugins:i386 libsdl2-2.0-0:i386 libfreetype6:i386 libdbus-1-3:i386 libsqlite3-0:i386
	git clone https://github.com/FeralInteractive/gamemode.git
	cd gamemode
	git checkout 1.3.1 # omit to build the master branch
  	./bootstrap.sh
	cd ..
	wget http://ftp.br.debian.org/debian/pool/main/d/dxvk/dxvk_0.96+ds1-1_all.deb
	wget http://ftp.br.debian.org/debian/pool/main/d/dxvk/dxvk-wine64-development_0.96+ds1-1_amd64.deb
	dpkg -i dxvk*
	sudo apt install -f
	clear
	echo "You have successfully installed lutris, dxvk and wine and can start gaming on linux"
	echo "The gamemode package was also installed, to get this working on lutris follow these steps"
	echo "1. Open lutris"
	echo "2. Click on the lutris logo in the upper left hand corner and open Preferences"
	echo "3. Open the System Options tab"
	echo "4. Add a environment variable with the following details:"
	echo "Key: LD_PRELOAD"
	echo "Value: "
  	find /usr -iname libgamemodeauto*

# Install for arch (copied from gamescript-archtest.sh)
  elif [ $DISTRO == 'arch' ]; then
	# TODO add nvidia driver install for arch
	# Removed Sudo in commands, as this script is meant to be run as root anyways.
	echo "enabling multilib repository"
	sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
	echo "finished enabling multilib repository"
	pacman -Sy wine
	echo "finished installing Wine"
	pacman -Sy lutris
	echo "finished installing lutris"
	echo "installing yay AUR helper"
	mkdir ~/yay
	git clone https://aur.archlinux.org/yay.git ~/yay
	cd ~/yay
	makepkg -si
	echo "Finised installing yay"
	echo "installing dxvk-bin"
	yay -S dxvk-bin
	echo "finished installing dxvk-bin"
	echo "installing gamemode"
	yay -S gamemode
	echo "finished installing gamemode"
	echo "We have finished installing everything we need to, and you are now ready to start gaming in Archlinux!"
	echo "In order to get the gamemode package to work in lutris:"
	echo "1. Open lutris"
	echo "2. CLick on the lutris logo in the upper left hand corner and open preferences"
	echo "3. Open the System Options tab"
	echo "4. Add an environment variable with the following details:"
	echo "Key: LD_PRELOAD"
	echo "Value: "
	find /usr -iname libgamemodeauto*
   fi

# EOF #
