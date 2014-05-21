#!/bin/bash -x

################################
# Install initial prequisites
################################

add-apt-repository -y ppa:chris-lea/node.js
apt-get update
apt-get install -y python-pip libffi-dev python-software-properties python g++ make postgresql-9.1 postgresql-server-dev-9.1 libpq-dev python-dev libldap2-dev libsasl2-dev python-m2crypto swig redis-server libssl-dev git nodejs > logs/install.error

#Don't remove sleep or hash -r.
sleep 3
pip install --upgrade pip
hash -r

echo -e "\n" >> logs/install.error
