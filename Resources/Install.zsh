#!/bin/zsh

#######################################################
#                                                     #
# Install Chord Provider on macOS                     #
#                                                     #
# For security reasons; this script is not executable #
# by double-clicking on it.                           #
#                                                     #
# To run it, you have to drop it into a Terminal      #
# window or drop it onto its icon.                    #
#                                                     #
#######################################################

## Nice colours

GREEN="\e[38;5;35m"

BLUE="\e[1m\e[38;5;27m"

RESET="\e[0m"

APPLICATION="\e[1m$GREEN""Chord Provider""$RESET"

# We need administration access to run this script
if [ $(id -u) != 0 ]; then
   echo "\n$BLUE""This install script requires administration permission to install $APPLICATION$RESET"
   echo "
It will do the following:

- Copy $APPLICATION to your applications folder
- Move $APPLICATION out of quarantine
"
   echo "\e[1m""Use it at your own risk...$RESET\n"
   sudo "$0" "$@"
   exit
fi

echo "\nCopy $APPLICATION to your Applications folder..."

rm -fr "/Applications/Chord Provider.app"

cp -R "${0:a:h}/ChordPro.app" /Applications/

echo "Remove the quarantine flag..."

xattr -rd com.apple.quarantine /Applications/ChordPro.app

echo "\n$BLUE""Done!$RESET\n\nEnjoy $APPLICATION on your Mac!\n"

