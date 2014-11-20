#!/bin/bash -x

############################## 
# Usage
#
# $1 - LOCATIONOFATMOSPHERE
# $2 - BRANCH_NAME
###############################


this_filename=$(basename $BASH_SOURCE)
output_for_logs="logs/$this_filename.log"
touch $output_for_logs

main(){

  LOCATIONOFATMOSPHERE=$1
  BRANCH_NAME=$2
  ####################################
  # Git clone setups
  ####################################

  #if [ ! "$BRANCH_NAME" = "" ]; then
  #  git clone -b "$BRANCH_NAME" https://github.com/iPlantCollaborativeOpenSource/atmosphere.git "$LOCATIONOFATMOSPHERE" 2>> $output_for_logs
  #else
  #  git clone https://github.com/iPlantCollaborativeOpenSource/atmosphere.git "$LOCATIONOFATMOSPHERE" 2>> $output_for_logs
  #fi

  BASEDIRECTORY=`pwd`

  if [ -d "$LOCATIONOFATMOSPHERE/.git" ]; then
     echo "git repository already established. Pulling latest.."
     cd "$LOCATIONOFATMOSPHERE"
     git fetch
     if [ ! "$BRANCH_NAME" = "" ]; then
        git checkout -f $BRANCH_NAME 2>> $output_for_logs
        git pull origin $BRANCH_NAME 2>> $output_for_logs
     else
        git pull origin master 2>> $output_for_logs
     fi
     cd "$BASEDIRECTORY"
  else
     echo "Cloning git repository"
     if [ ! "$BRANCH_NAME" = "" ]; then
        git clone -b "$BRANCH_NAME" https://github.com/iPlantCollaborativeOpenSource/atmosphere.git "$LOCATIONOFATMOSPHERE" 2>> $output_for_logs
     else
        git clone https://github.com/iPlantCollaborativeOpenSource/atmosphere.git "$LOCATIONOFATMOSPHERE" 2>> $output_for_logs
     fi

   fi

}

# Execution Thread
main "$@"
