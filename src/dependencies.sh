#!/bin/bash -x

################################
# Install initial prequisites
################################

apt-get install -y python-software-properties
add-apt-repository -y ppa:chris-lea/node.js
apt-get update
apt-get install -y libffi-dev python g++ make postgresql postgresql-contrib postgresql-server-dev-all libpq-dev python-dev libldap2-dev libsasl2-dev python-m2crypto swig redis-server libssl-dev git nodejs > install.log

npm update npm -g
