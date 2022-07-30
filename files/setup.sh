#!/bin/bash

# Make sure everything is up and ahppy

sleep 30
sudo apt update -y && sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
sudo apt install -y gcc make git

sudo mkdir /apps
sudo chown ubuntu:ubuntu /apps
git clone https://github.com/volatilityfoundation/volatility3.git /apps/vol3