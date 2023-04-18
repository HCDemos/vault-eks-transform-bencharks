#!/bin/bash
set -x

# set ulimit for open files
echo "ubuntu soft nofile 65535" | sudo tee -a /etc/security/limits.conf

# Install pip3 and locust necessary dependencies
sudo apt-get update
#sudo apt-get -y install python3-pip
sudo apt-get install python3-setuptools
sudo python3 -m easy_install install pip
python3 -m pip --version
pip3 install locust
#sudo mkdir -p /home/ubuntu/test-data
sudo cp /tmp/vault-locust-benchmarks.tar.gz /home/ubuntu
#sudo chmod 700 /home/ubuntu/test-data
sudo chown -R ubuntu /home/ubuntu/vault-locust-benchmarks.tar.gz
tar -xvf /home/ubuntu/vault-locust-benchmarks.tar.gz
#install vault so we can use the vault client if needed
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install vault



