#!/bin/bash
wget https://apt.puppetlabs.com/puppet6-release-xenial.deb
sudo dpkg -i puppet6-release-xenial.deb
sudo apt-get update
sudo apt-get -y install puppetserver
sudo apt-get -y install git git-core curl zlib1g-dev build-essential gcc libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev gnupg rng-tools apt-transport-https zsh curl
sudo systemctl start puppetserver
sudo apt-get install -y ntp ntpdate
sudo ntpdate -u 0.ubuntu.pool.ntp.org
sudo timedatectl set-timezone America/Santiago
sudo locale-gen es_CL