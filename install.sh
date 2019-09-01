#!/bin/bash

# Get the IP address
export IP="$(hostname -I | sed -e 's/[[:space:]]*$//')"

echo -e "####################\nYour IP address is: \n# $IP\n####################"

sudo apt-get update

sudo apt-get install -y socat jq avahi-daemon apt-transport-https ca-certificates software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0eBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update

sudo apt-get install -y docker-ce

curl -sL https://raw.githubusercontent.com/home-assistant/hassio-installer/master/hassio_install.sh | sudo bash -

echo -e "\nSuccess! go to\n\nhttp://$IP:8123\n"
