#!/bin/bash -x

################################
# Usage
#
# RESET_FLAG - $1
################################

################################
# Setup troposphere
################################

this_filename=$(basename $BASH_SOURCE)
output_for_logs="logs/$this_filename.log"

touch $output_for_logs

main(){

  RESET_FLAG=$1
  if [ "$RESET_FLAG" = "atmosphere" ]; then
      service atmosphere celery-restart 2>> $output_for_logs
  elif [ "$RESET_FLAG" = "celery" ]; then
      service celeryd restart 2>> $output_for_logs
  elif [ "$RESET_FLAG" = "apache" ]; then
      service apache2 restart 2>> $output_for_logs
  fi
}

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters" 2>> $output_for_logs
    echo $@ 2> $output_for_logs
    exit -1
else
    main $@
fi
