#!/bin/bash -x
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
  "$VIRTUAL_ENV_ATMOSPHERE/bin/pip" install -r "$LOCATIONOFATMOSPHERE/requirements.txt" --upgrade >> $output_for_logs

}
if [ "$#" -ne 2 ]; then
  echo "Illegal number of parameters" 2>> $output_for_logs
  echo $@ 2> $output_for_logs
  exit 01
else
  main $@
fi
