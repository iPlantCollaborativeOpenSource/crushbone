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

  if [ ! "$BRANCH_NAME" = "" ]; then
    git clone -b "$BRANCH_NAME" https://github.com/iPlantCollaborativeOpenSource/atmosphere.git "$LOCATIONOFATMOSPHERE" 2>> $output_for_logs
  else
    git clone https://github.com/iPlantCollaborativeOpenSource/atmosphere.git "$LOCATIONOFATMOSPHERE" 2>> $output_for_logs
  fi

}

# Execution Thread
if [ "$#" -ne 2 ]; then
  echo "Illegal number of parameters" 2> $output_for_logs
  echo $@ 2> $output_for_logs
  exit -1
else
 main "$@"
fi
