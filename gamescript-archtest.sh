#!/bin/bash
# A modified version of the original gamescript file.
#CURRENTLY NOT SUITABLE FOR PRODUCTION USE
# POSSIBLE BUGS COULD HARM THE SYSTEM
#Modified version create by Chris House (cjbrick910 on github)
#look at my other repos: https://github.com/cjbrick910/
# https://github.com/Simulink01/gamescript/
# Copyright (c) 2019 Simulink. Released under the GNU General Public Lisence v3.0. (https://www.gnu.org/licenses/gpl-3.0.en.html)

# Detect Debian users running the script with "sh" instead of bash
if readlink /proc/$$/exe | grep -q "dash"; then
	echo "This script needs to be run with bash, not sh"
	exit
fi
# Get linux distro name
DISTRO=$( cat /etc/*-release | tr [:upper:] [:lower:] | grep -Poi '(debian|ubuntu|red hat|centos|arch)' | uniq )
if [ -z $DISTRO ]; then
    DISTRO='unknown'
fi
echo "Detected Distro: $DISTRO"
if [ $DISTRO != 'arch' ]; then
	echo "This script is not compatible with your distro"
	echo "Please download the correct script for your distro from the repository"
	exit
fi
#install for arch
if [ $DISTRO == 'arch' ]; then
	echo "enabling multilib repository"
	sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
	echo "finished enabling multilib repository"
	sudo pacman -Sy wine
	echo "finished installing Wine"
	sudo pacman -Sy lutris
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
	echo "2. CLick on the lutris logo in the uper right hand corner and open preferences"
	echo "3. Open the System Options tab"
	echo "4. Add an environment variable with the following details:"
	echo "Key: LD_PRELOAD"
	echo "Value: "
find /usr -iname libgamemodeauto*
fi
# EOF #
