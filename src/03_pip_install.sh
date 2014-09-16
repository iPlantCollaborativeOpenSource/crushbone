#!/bin/bash -x

this_filename=$(basename $BASH_SOURCE)
output_for_logs="logs/$this_filename.log"

apt-get install -y python-pip 2> $output_for_logs

#Don't remove sleep or hash -r.
sleep 3
pip install "pip<1.5" "virtualenv==1.10.1" 2>> $output_for_logs
hash -r
