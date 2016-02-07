#!/bin/bash
sudo apt-get install zsh
#see https://gist.github.com/tsabat/1498393
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
chsh -s `which zsh`
echo "log out and then back in"
