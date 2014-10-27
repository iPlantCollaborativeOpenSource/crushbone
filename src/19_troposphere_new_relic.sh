#!/bin/bash -x

##############################
# Usage
#
#  LOCATIONOFSETUPFILE - $1
#  LOCATIONOFTROPOSPHERE - $2
# 
##############################

this_filename=$(basename $BASH_SOURCE)
output_for_logs="logs/$this_filename.log"
touch $output_for_logs

main(){

  if [ "$#" -ne 2 ]; then
    echo "Illegal number of parameters" 2>> $output_for_logs
    echo $@ 2> $output_for_logs
    exit -1
  fi

  ## Initialize command line vars
  LOCATIONOFSETUPFILE=$1
  LOCATIONOFTROPOSPHERE=$2
}

run_steps(){
  ####################################
  # Initial Atmosphere Setup
  ####################################


  if [ -e "$LOCATIONOFSETUPFILE/troposphere_newrelic.ini" ] && [ ! -f "$LOCATIONOFTROPOSPHERE/extras/newrelic/troposphere_newrelic.ini" ]; then
    mkdir -p "$LOCATIONOFTROPOSPHERE/extras/newrelic"
    echo "Command: cp $LOCATIONOFSETUPFILE/troposphere_newrelic.ini $LOCATIONOFTROPOSPHERE/extras/newrelic/troposphere_newrelic.ini" >> $output_for_logs
    cp "$LOCATIONOFSETUPFILE/troposphere_newrelic.ini" "$LOCATIONOFTROPOSPHERE/extras/newrelic/troposphere_newrelic.ini" 2>> $output_for_logs;
  fi
}

#EXECUTION PATH:
main "$@"
run_steps
