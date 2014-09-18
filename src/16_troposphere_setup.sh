#!/bin/bash -x

################################
# Usage
#
# LOCATIONOFTROPOSPHERE - $1
# LOCATIONOFTROPOSPHEREKEY - $2
# SERVERNAME - $3 
################################

this_filename=$(basename $BASH_SOURCE)
output_for_logs="logs/$this_filename.log" 

touch $output_for_logs

main(){

  LOCATIONOFTROPOSPHERE=$1
  LOCATIONOFTROPOSPHERELOCALFILE=$2
  LOCATIONOFTROPOSPHEREKEY=$2
  SERVERNAME=$3

  #####################
  ## Install yuglify
  #####################
  npm -g install yuglify

  ################################
  # Setup Troposphere Project
  ################################
  BASEDIRECTORY=`pwd`
  

  git clone https://github.com/iPlantCollaborativeOpenSource/troposphere.git $LOCATIONOFTROPOSPHERE
  if [ -e "$LOCATIONOFTROPOSPHERELOCALFILE/local.py" ]; then
    cp $LOCATIONOFTROPOSPHERELOCALFILE/local.py $LOCATIONOFTROPOSPHERE/troposphere/settings/local.py 2>> $output_for_logs;
    sed -i "s/SERVERNAME/$SERVERNAME/g" $LOCATIONOFTROPOSPHERE/troposphere/settings/local.py 2>> $output_for_logs
  else
    cp $LOCATIONOFTROPOSPHERE/troposphere/settings/local.py.dist $LOCATIONOFTROPOSPHERE/troposphere/settings/local.py
    sed -i "s/SERVERNAME/$SERVERNAME/g" $LOCATIONOFTROPOSPHERE/troposphere/settings/local.py 2>> $output_for_logs
  fi

  #if [ -e "$LOCATIONOFTROPOSPHEREKEY/troposhere.key" ]; then
  #  cp $LOCATIONOFTROPOSPHEREKEY/troposhere.key $LOCATIONOFTROPOSPHERE 2>> $output_for_logs;
  #else
  #  echo "Need to generate a groupy key and place it in the $LOCATIONOFTROPOSPHERE directory." 2>> $output_for_logs;
  #fi
  mkdir -p "$LOCATIONOFTROPOSPHERE/logs/"
  touch  "$LOCATIONOFTROPOSPHERE/logs/troposphere.log"
  chown -R www-data:www-data $LOCATIONOFTROPOSPHERE
  cd $LOCATIONOFTROPOSPHERE
  make
  cd $BASEDIRECTORY

  #User input needed warning here..
  echo "Edit $LOCATIONOFTROPOSPHERE/troposphere/settings/local.py with your own settings. You'll have to generate a new keypair from Groupy for the Troposphere application.\n The configuration variable OAUTH_PRIVATE_KEY_PATH should refer to the absolute path of that key."
}

if [ "$#" -ne 3 ]; then
  echo "Illegal number of parameters" 2>> $output_for_logs
  echo $@ 2> $output_for_logs
  exit -1
else
  #EXECUTION
  main $@
fi
