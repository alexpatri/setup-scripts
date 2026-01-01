#!/usr/bin/env bash

curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install nodejs -y 

node --version
npm --version
