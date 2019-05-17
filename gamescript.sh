#!/bin/bash
# https://github.com/
# Copyright (c) 2019 Simulink. Released under the GNU General Public Lisence v3.0. (https://www.gnu.org/licenses/gpl-3.0.en.html)

# Detect Debian users running the script with "sh" instead of bash
if readlink /proc/$$/exe | grep -q "dash"; then
	echo "This script needs to be run with bash, not sh"
	exit
fi

# Make sure script is running as root
if [[ "$EUID" -ne 0 ]]; then
 echo "Sorry, you need to run script this as root."
 exit
fi

# Get linux distro name
DISTRO=$( cat /etc/*-release | tr [:upper:] [:lower:] | grep -Poi '(debian|ubuntu|red hat|centos|nameyourdistro)' | uniq )
if [ -z $DISTRO ]; then
    DISTRO='unknown'
fi
echo "Detected Distro: $DISTRO"
# See if compatable
if [ $DISTRO == 'ubuntu' ]; then
	echo "✔️ Your distro is compatable with this script!"
else
	echo "❌ Unfortunatly, your distro is NOT compatable with this script."
	echo "If you would like to see this script work with your distro you can help by contributing."
	exit
fi

# Install for ubuntu
if [ $DISTRO == 'ubuntu' ]; then
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
	echo "You have succesfully installed lutris, dxvk and wine and can start gaming on linux"
	echo "The gamemode package was also installed, to get this working on lutris follow these steps"
	echo "1. Open lutris"
	echo "2. Click on the lutris logo in the upper right hand corner and open Preferances"
	echo "3. Open the System Options tab"
	echo "4. Add a enviorment variable with the following details:"
	echo "Key: LD_PRELOAD"
	echo "Value: "
  find /usr -iname libgamemodeauto*
fi

# EOF #
