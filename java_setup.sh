#!/bin/bash

#java
wget --no-cookies --header "Cookie: oraclelicencse=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u51-b16/jdk-8u51-linux-x64.tar.gz
sudo mkdir /usr/java
sudo cp ~/jdk-8u51-linux-x64.tar.gz /usr/java/
sudo tar xvf /usr/java/jdk-8u51-linux-x64.tar.gz -C /usr/java/
echo "export PATH=/usr/java/jdk1.8.0_51/bin/:$PATH" >> ~/.bashrc

#intellij
wget https://download.jetbrains.com/idea/ideaIC-14.1.4.tar.gz
tar xvf ideaIC-14.1.4.tar.gz
echo "export PATH=~/idea-IC-141.1532.4/bin:$PATH" >> ~/.bashrc


