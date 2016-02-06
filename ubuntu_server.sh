#!/bin/sh
echo 'net.ipv6.conf.all.disable_ipv6 = 1' | sudo tee --append /etc/sysctl.conf
echo 'net.ipv6.conf.default.disable_ipv6 = 1' | sudo tee --append /etc/sysctl.conf
echo 'net.ipv6.conf.lo.disable_ipv6 = 1' | sudo tee --append /etc/sysctl.conf

sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade
sudo apt-get autoremove
sudo apt-get install xinit
sudo apt-get install xorg
sudo apt-get install libcairo-gobject2
sudo apt-get install awesome
sudo apt-get install firefox

cp -r ~/devsetup/dot_files/. ~
cp /etc/xdg/awesome/rc.lua ~/.config/awesome/.
patch ~/.config/awesome/rc.lua < ~/devsetup/rc.lua.patch

git clone https://github.com/mikar/awesome-themes ~/.config/awesome/themes
ln -s ~/.config/awesome/themes/wmii ~/.config/awesome/themes/my_theme
update-menus
sudo dpkg-reconfigure unattended-upgrades

sudo apt-get install zsh
#see https://gist.github.com/tsabat/1498393
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
chsh -s `which zsh`
echo "log out and then back in"
