#!/bin/bash -x
PS4='$(date "+%s.%N ($LINENO) + ")'

this_filename=$(basename $BASH_SOURCE)
output_for_logs="logs/$this_filename.log"

apt-get install -y python-pip 2> $output_for_logs

#Don't remove sleep or hash -r.
sleep 3
pip install --upgrade "pip<1.5" "virtualenv" "wheel" 2>> $output_for_logs
hash -r
