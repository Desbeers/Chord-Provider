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

APP="\e[1m\e[38;5;28m"

ACCENT="\e[1m\e[38;5;100m"

RESET="\e[0m"

APPLICATION="$APP""Chord Provider""$RESET"

# We need administration access to run this script
if [ $(id -u) != 0 ]; then
   echo "\n$ACCENT""This install script requires administration\npermission to install $APPLICATION$ACCENT on your Mac.$RESET"
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

cp -R "${0:a:h}/Chord Provider.app" /Applications/

echo "Remove the quarantine flag..."

xattr -rd com.apple.quarantine "/Applications/Chord Provider.app"

echo "\n$ACCENT""Done!$RESET\n\nEnjoy $APPLICATION on your Mac!\n"

