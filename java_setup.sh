#!/bin/bash

sudo mkdir /usr/local/

#java
jdk_tar=jdk-8u74-linux-x64.tar.gz
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u74-b02/$jdk_tar -O ~/Downloads/$jdk_tar
sudo cp ~/Downloads/$jdk_tar /usr/local/
sudo tar xvf /usr/local/$jdk_tar -C /usr/local/
ln -s /usr/local/jdk1.8.0_74 /usr/local/java
echo "export PATH=/usr/java/bin/:$PATH" >> ~/.zshrc

#intellij
intellij_tar=ideaIU-15.0.3.tar.gz
wget https://download.jetbrains.com/idea/$intellij_tar -O ~/Downloads/$intellij_tar
sudo cp ~/Downloads/$intellij_tar /usr/local/
sudo tar xvf /usr/local/$intellij_tar -C /usr/local/
ln -s /usr/local/idea-IC-143.1821.5 /usr/local/idea
echo "export PATH=/usr/local/idea/bin:$PATH" >> ~/.zshrc

#maven
maven333_tar=apache-maven-3.3.3-bin.tar.gz
wget http://archive.apache.org/dist/maven/maven-3/3.3.3/binaries/maven333_tar -O ~/Downloads/$maven333_tar
sudo cp ~/Downloads/$maven333_tar /usr/local/
sudo tar xvf /usr/local/maven/$maven333_tar -C /usr/local/
ln -s /usr/local/apache-maven-3.3.3 /usr/local/maven
echo "export PATH=/usr/local/maven/bin:$PATH" >> ~/.zshrc


