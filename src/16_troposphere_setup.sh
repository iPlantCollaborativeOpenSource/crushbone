#!/bin/bash -x
PS4='$(date "+%s.%N ($LINENO) + ")'

################################
# Usage
#
# LOCATIONOFTROPOSPHERE - $1
# LOCATIONOFTROPOSPHEREKEY - $2
# SERVERNAME - $3
# BRANCH_NAME -$4
# JENKINS_REBUILD - $5
################################

this_filename=$(basename $BASH_SOURCE)
output_for_logs="logs/$this_filename.log" 

touch $output_for_logs

main(){

  LOCATIONOFTROPOSPHERE=$1
  VIRTUAL_ENV_TROPOSPHERE=$2
  LOCATIONOFTROPOSPHERELOCALFILE=$3
  LOCATIONOFTROPOSPHEREKEY=$3
  SERVERNAME=$4
  BRANCH_NAME=$5
  JENKINS_REBUILD=$6

  #####################
  ## Install yuglify
  #####################
  npm -g install yuglify 2>> $output_for_logs

  ################################
  # Setup Troposphere Project
  ################################
  BASEDIRECTORY=`pwd`

  echo "Testing directory: $LOCATIONOFTROPOSPHERE/.git"
  if [ -d "$LOCATIONOFTROPOSPHERE/.git" ]; then
     echo "git repository already established. Pulling latest.."
     cd "$LOCATIONOFTROPOSPHERE"
     git fetch
     if [ ! "$BRANCH_NAME" = "" ]; then
        git checkout -f $BRANCH_NAME
        git pull origin $BRANCH_NAME
     else
        git pull origin master
     fi
     cd "$BASEDIRECTORY"
  else
     echo "Cloning git repository"
     if [ ! "$BRANCH_NAME" = "" ]; then
        git clone -b "$BRANCH_NAME" https://github.com/iPlantCollaborativeOpenSource/troposphere.git "$LOCATIONOFTROPOSPHERE" 2>> $output_for_logs
     else
        git clone https://github.com/iPlantCollaborativeOpenSource/troposphere.git "$LOCATIONOFTROPOSPHERE" 2>> $output_for_logs
     fi

  fi

  echo "Command: cp $LOCATIONOFTROPOSPHERELOCALFILE/variables.ini $LOCATIONOFTROPOSPHERE/variables.ini" >> $output_for_logs
  cp "$LOCATIONOFTROPOSPHERELOCALFILE/variables.ini" "$LOCATIONOFTROPOSPHERE/variables.ini" 2>> $output_for_logs;
  sed -i "s/SERVERNAME/$SERVERNAME/g" "$LOCATIONOFTROPOSPHERE/variables.ini" 2>> $output_for_logs

  #Need jinja2
  mkdir -p "$VIRTUAL_ENV_TROPOSPHERE"
  if [ ! -f "$VIRTUAL_ENV_TROPOSPHERE/bin/activate" ]; then
    virtualenv "$VIRTUAL_ENV_TROPOSPHERE" 2>> $output_for_logs
  fi
  echo "V_ENV=$VIRTUAL_ENV_TROPOSPHERE"

  source "$VIRTUAL_ENV_TROPOSPHERE/bin/activate" 2>> $output_for_logs
  pip install -r $LOCATIONOFTROPOSPHERE/requirements.txt 2>> $output_for_logs

  #Build config scripts
  echo "PATH=$PATH"
  echo "`pip freeze`"
  cd "$LOCATIONOFTROPOSPHERE"

  ./scripts/generate_configs.py  # This is true for builds pre-Jamming

  ./configure  # Use this for builds post-jamming junglefowl

  # GO BACK
  cd "$BASEDIRECTORY"

  mkdir -p "$LOCATIONOFTROPOSPHERE/logs/"
  touch  "$LOCATIONOFTROPOSPHERE/logs/troposphere.log"
  chown -R www-data:www-data "$LOCATIONOFTROPOSPHERE"
  cd "$LOCATIONOFTROPOSPHERE"
  if [[ "$JENKINS_REBUILD" == "true" ]]; then
      make jenkins
  else
      make
  fi
  cd "$BASEDIRECTORY"

  #User input needed warning here..
  #FIXME: This gets absolutely buried in text, perhaps we should print this at
  #       the end of the install.
  echo "Edit $LOCATIONOFTROPOSPHERE/troposphere/settings/local.py with your own settings. You'll have to generate a new keypair from Groupy for the Troposphere application.\n The configuration variable OAUTH_PRIVATE_KEY_PATH should refer to the absolute path of that key."
}

main "$@"
