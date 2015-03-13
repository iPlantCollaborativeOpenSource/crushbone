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
  LOCATIONOFTROPOSPHERELOCALFILE=$2
  LOCATIONOFTROPOSPHEREKEY=$2
  SERVERNAME=$3
  BRANCH_NAME=$4
  JENKINS_REBUILD=$5

  #####################
  ## Install yuglify
  #####################
  npm -g install yuglify 2>> $output_for_logs 

  ################################
  # Setup Troposphere Project
  ################################
  BASEDIRECTORY=`pwd`
  

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

  #FIXME: Instead of testing for file existence, test mod time difference
  if [[ ! -e "$LOCATIONOFTROPOSPHERE/troposphere/settings/local.py" ]]; then
      #Troposphere settings missing! Make a copy of secrets, or a copy of dist
      if [ -e "$LOCATIONOFTROPOSPHERELOCALFILE/local.py" ]; then
        cp "$LOCATIONOFTROPOSPHERELOCALFILE/local.py" "$LOCATIONOFTROPOSPHERE/troposphere/settings/local.py" 2>> $output_for_logs;
        sed -i "s/SERVERNAME/$SERVERNAME/g" "$LOCATIONOFTROPOSPHERE/troposphere/settings/local.py" 2>> $output_for_logs
      else
        cp "$LOCATIONOFTROPOSPHERE/troposphere/settings/local.py.dist" "$LOCATIONOFTROPOSPHERE/troposphere/settings/local.py"
        sed -i "s/SERVERNAME/$SERVERNAME/g" "$LOCATIONOFTROPOSPHERE/troposphere/settings/local.py" 2>> $output_for_logs
      fi
  fi
  #FIXME: Probably need to change some of these 'local.py' values based on what
  #       we know about the server already.

  #if [ -e "$LOCATIONOFTROPOSPHEREKEY/troposhere.key" ]; then
  #  cp $LOCATIONOFTROPOSPHEREKEY/troposhere.key $LOCATIONOFTROPOSPHERE 2>> $output_for_logs;
  #else
  #  echo "Need to generate a groupy key and place it in the $LOCATIONOFTROPOSPHERE directory." 2>> $output_for_logs;
  #fi
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
