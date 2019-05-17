#!/bin/bash
# A modified version of the original gamescript file.
#CURRENTLY NOT SUITABLE FOR PRODUCTION USE
# POSSIBLE BUGS COULD HARM THE SYSTEM
# https://github.com/Simulink01/gamescript/
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
if [$DISTRO == 'arch' ]; then
		
# EOF #
