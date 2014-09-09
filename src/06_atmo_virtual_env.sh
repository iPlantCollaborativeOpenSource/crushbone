#!/bin/bash -x

##############################
# Usage
#
# $1 - $VIRTUAL_ENV_ATMOSPHERE
##############################

this_filename=$(basename $BASH_SOURCE)
output_for_logs="logs/$this_filename.log"


main(){

  VIRTUAL_ENV_ATMOSPHERE=$1
  ################################
  # Setup Virtualenv
  ################################
  which pip
  pip install --upgrade virtualenv 2> $output_for_logs
  
  mkdir -p $VIRTUAL_ENV_ATMOSPHERE
  if [ ! -f $VIRTUAL_ENV_ATMOSPHERE/bin/activate ]; then
    virtualenv $VIRTUAL_ENV_ATMOSPHERE 2>> $output_for_logs
  fi
  
  source $VIRTUAL_ENV_ATMOSPHERE/bin/activate 2>> $output_for_logs
  $VIRTUAL_ENV_ATMOSPHERE/bin/pip install pip==1.4.1

  ################################
  # Setup M2CryptoConfiguration
  ################################

  m2crypto_loc=$VIRTUAL_ENV_ATMOSPHERE/lib/python2.7/site-packages/M2Crypto
  if [ ! -L $m2crypto_loc ]; then
    sudo ln -s /usr/lib/python2.7/dist-packages/M2Crypto $m2crypto_loc 2> $output_for_logs
  else
    echo "$m2crypto_loc already exists. No action required." >> $output_for_logs
  fi
}

# Execution Thread
if [ "$#" -ne 1 ]; then
  echo "Illegal number of parameters" 2> $output_for_logs
  echo $@ 2> $output_for_logs
  exit -1
else
  main $@
fi

