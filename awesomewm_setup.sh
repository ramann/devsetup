#!/bin/bash
sudo apt-get install xinit
sudo apt-get install xorg
sudo apt-get install libcairo-gobject2
sudo apt-get install awesome
sudo apt-get install firefox
sudo dpkg-reconfigure unattended-upgrades

cp -r ~/devsetup/dot_files/. ~
mkdir -p ~/.config/awesome
cp /etc/xdg/awesome/rc.lua ~/.config/awesome/.
patch ~/.config/awesome/rc.lua < ~/devsetup/rc.lua.patch

git clone https://github.com/mikar/awesome-themes ~/.config/awesome/themes
ln -s ~/.config/awesome/themes/wmii ~/.config/awesome/themes/my_theme
update-menus

