#!/bin/bash -x

################################
# Usage
#
# LOCATIONOFTROPOSPHERE - $1
# 
################################

this_filename=$(basename $BASH_SOURCE)
output_for_logs="logs/$this_filename.log" 

touch $output_for_logs

main(){

  LOCATIONOFTROPOSPHERE=$1
  LOCATIONOFTROPOSPHERELOCALFILE=$2
  LOCATIONOFTROPOSPHEREKEY=$2

  ################################
  # Setup Troposphere Project
  ################################
  BASEDIRECTORY=`pwd`
  
  git clone https://github.com/iPlantCollaborativeOpenSource/troposphere.git $LOCATIONOFTROPOSPHERE
  if [ -e "$LOCATIONOFTROPOSPHERELOCALFILE/local.py" ]; then
    cp $LOCATIONOFTROPOSPHERELOCALFILE/local.py $LOCATIONOFTROPOSPHERE/troposphere/settings/local.py 2>> $output_for_logs;
  else
    cp $LOCATIONOFTROPOSPHERE/troposphere/settings/local.py.dist $LOCATIONOFTROPOSPHERE/troposphere/settings/local.py
  fi

  if [ -e "$LOCATIONOFTROPOSPHEREKEY/troposhere.key" ]; then
    cp $LOCATIONOFTROPOSPHEREKEY/troposhere.key $LOCATIONOFTROPOSPHERE 2>> $output_for_logs;
  else
    echo "Need to generate a groupy key and place it in the $LOCATIONOFTROPOSPHERE directory." 2>> $output_for_logs;
  fi
  ## NOTE: Now we use make for all of this.
  ## Re-add if any of these steps are NOT covered by make.
  ## pip install --upgrade pip 2>> $output_for_logs
  ## pip install -r $LOCATIONOFTROPOSPHERE/requirements.txt 2>> $output_for_logs
  ## npm update npm -g 2>> $output_for_logs
  ## npm install gulp -g 2>> $output_for_logs
  ## npm install bower -g 2>> $output_for_logs
  ## gem install sass 2>> $output_for_logs
  ## BASEDIRECTORY=`pwd`
  ## cd $LOCATIONOFTROPOSPHERE
  ## npm install 2>> $output_for_logs
  ## bower install --allow-root --config.interactive=false 2>> $output_for_logs
  ## #Build stuff with glup
  ## gulp 2>> $output_for_logs
  ## chown -R www-data:www-data troposphere/assets
  ## service apache2 restart
  ## cd $BASEDIRECTORY
  cd $LOCATIONOFTROPOSPHERE
  make
  cd $BASEDIRECTORY

  #User input needed warning here..
  echo "Edit $LOCATIONOFTROPOSPHERE/troposphere/settings/local.py with your own settings. You'll have to generate a new keypair from Groupy for the Troposphere application.\n The configuration variable OAUTH_PRIVATE_KEY_PATH should refer to the absolute path of that key."
}

if [ "$#" -ne 2 ]; then
  echo "Illegal number of parameters" 2>> $output_for_logs
  echo $@ 2> $output_for_logs
  exit -1
else
  #EXECUTION
  main $@
fi
