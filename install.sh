#!/bin/sh
printf '\033c'
echo "Mankind is dead"
sleep 0.8
echo "Hell is full"
sleep 0.8
echo "Blood is fuel"
sleep 0.8
echo "Kawakijin's Dotfile Deployer loaded..."
echo "Begining dotfile deployment, please wait warmly..."

user=$(whoami)
homesweethome="$HOME"

# Promt to install packages 
# TODO Move this to a new repo for arch install
read -r -p "Would you like to install packages in the .pkglist? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then yay -Syu --needed - < pkglist.txt
else echo "Skipping Packages"
fi

#echo "Disabling Akonadi"
#akonadictl stop

echo "disabling Baloo"
balooctl disable

# Prompt for polybar
# TODO check if this can overwrite files properly
read -r -p "Would you like to Apply the Polybar customisation [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then echo "Installing and applying polybar customisation" &&  cp -R ".config/polybar" "$homesweethome/.config && rm -R .config/polybar"
else echo "Skipping Polybar customisation"
fi

# Neofetch
echo "Applying Neofetch config"
mv -i .config/neofetch/config.conf ~/.config/neofetch
read -r -p "Do you have an image you would like to use in neofetch? (Nyarch is included in .config/neofetch/Nyarch.png) [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then read -r -p "Enter the path to the image (Example: /home/kawa/Desktop/Picture.png): " image && cp "$image" "/$homesweethome/.config/neofetch" && sed -i -e "s|THEIMAGEGOESHERE|$image|g" "$homesweethome/.config/neofetch/config.conf"
else echo "Skipping Neofetch Image" 
fi                                                                                                                   

# FSearch config
# TODO Check that this works

echo Applying FSearch config and adding a timer (Index updates every 15 minutes)

# TODO mv /etc/systemd/system/fsearch /etc/systemd/system... maybe rename the thing to reduce possible issues
echo "Applying FSearch conf"
cp -R ".config/fsearch" "$homesweethome/.config/fsearch" && rm -R ".config/fsearch"
 
systemctl enable fsearch.timer && systemctl start fsearch.timer


# TODO Syncthing config


# TODO Currently my KDE settings are borked, so when they're set up consider trying https://github.com/Prayag2/konsave to save config since KDE is a total clusterfuck

# TODO Insert something about swapfiles here


# TODO Explain this somewhere, this section will make directories I am familiar with such as /~/Videos/ytdl, /~/Documents/Krita Projects, etc.
read -r -p "Make ~ directories [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]] # Order is home, Documents, Pictures and Videos. This should be adjusted to handle cases where more or less files exist, perhaps you should make the entire tree yuorself here.
then cd ~ && mkdir Obsidian Keepass Syncthing VMs && cd Documents && mkdir Calendars "GP#" "Kdenlive projects" Notes Cards Programming Spreadsheets Slides && cd .. && cd Pictures && mkdir Wallpapers && cd .. && cd Videos && mkdir "OBS Recordings" YTDL Lore
else echo "Skipping direcctory setup"
fi


