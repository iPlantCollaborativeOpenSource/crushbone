#!/bin/bash -x
##############################
# Usage 
#
# $1 - LOCATIONOFATMOSPHERE
##############################


this_filename=$(basename $BASH_SOURCE)
output_for_logs="logs/$this_filename.log" 
touch $output_for_logs


main(){
  
  LOCATIONOFATMOSPHERE=$1

  pip install -r $LOCATIONOFATMOSPHERE/requirements.txt --upgrade >> $output_for_logs

}
if [ "$#" -ne 1 ]; then
  echo "Illegal number of parameters" 2>> $output_for_logs
  echo $@ 2> $output_for_logs
  exit 01
else
  main $@
fi
