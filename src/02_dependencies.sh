#!/bin/bash -x

this_filename=$(basename $BASH_SOURCE)
output_for_logs="logs/$this_filename.log"
################################
# Install initial prequisites
################################

apt-get install -y python-software-properties 2> $output_for_logs
add-apt-repository -y ppa:chris-lea/node.js 2>> $output_for_logs 
apt-get update
apt-get install -y libffi-dev python g++ make postgresql postgresql-contrib postgresql-server-dev-all libpq-dev python-dev libldap2-dev libsasl2-dev python-m2crypto swig redis-server libssl-dev git nodejs ruby1.9.1 2>> $output_for_logs 
apt-get install -y libxml2-dev libxslt1-dev python-tk zlib1g-dev 2>> $output_for_logs 
apt-get install -y apache2 libapache2-mod-auth-cas libapache2-mod-wsgi libapache2-mod-macro 2>> $output_for_logs
npm update npm -g 2>> $output_for_logs 
