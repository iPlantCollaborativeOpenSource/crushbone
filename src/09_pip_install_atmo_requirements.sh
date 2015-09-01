#!/bin/bash -x
PS4='$(date "+%s.%N ($LINENO) + ")'
##############################
# Usage 
#
# LOCATIONOFATMOSPHERE -$1
# VIRTUAL_ENV_ATMOSPHERE - $2
##############################


this_filename=$(basename $BASH_SOURCE)
output_for_logs="logs/$this_filename.log" 
touch $output_for_logs


main(){
  
  LOCATIONOFATMOSPHERE=$1
  VIRTUAL_ENV_ATMOSPHERE=$2
  JENKINS=$3
  TEST=$4
  "$VIRTUAL_ENV_ATMOSPHERE/bin/pip" install -U -r "$LOCATIONOFATMOSPHERE/requirements.txt" >> $output_for_logs
  if [[ "$JENKINS" = "true" || "$TEST" = "true" ]]; then
      # Required to run jenkins OR a test
      "$VIRTUAL_ENV_ATMOSPHERE/bin/pip" install -U -r "$LOCATIONOFATMOSPHERE/dev_requirements.txt" >> $output_for_logs
  fi
  "$VIRTUAL_ENV_ATMOSPHERE/bin/wheel" install-scripts celery

}
if [ "$#" -ne 4 ]; then
  echo "Illegal number of parameters" 2>> $output_for_logs
  echo $@ 2> $output_for_logs
  exit 01
else
  main "$@"
fi
