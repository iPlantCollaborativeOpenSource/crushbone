#!/bin/bash -x

apt-get install -y python-pip >> install.log

#Don't remove sleep or hash -r.
sleep 3
pip install --upgrade pip
hash -r

echo -e "\n" >> install.log
