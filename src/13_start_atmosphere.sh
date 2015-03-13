#!/bin/bash -x
PS4='$(date "+%s.%N ($LINENO) + ")'

################################
# Usage
#
# RESET_FLAG - $1
# LOCATIONOFATMOSPHERE - $2 
################################

################################
# Setup troposphere
################################

this_filename=$(basename $BASH_SOURCE)
output_for_logs="logs/$this_filename.log"

touch $output_for_logs

main(){

  RESET_FLAG=$1
  LOCATIONOFATMOSPHERE=$2
  
  "$LOCATIONOFATMOSPHERE/scripts/set_permissions.sh" $LOCATIONOFATMOSPHERE
  if [ "$RESET_FLAG" = "atmosphere" ]; then
      service atmosphere celery-restart 2>> $output_for_logs
  elif [ "$RESET_FLAG" = "celery" ]; then
      service celeryd restart 2>> $output_for_logs
  elif [ "$RESET_FLAG" = "apache" ]; then
      service apache2 restart 2>> $output_for_logs
  fi
}

if [ "$#" -ne 2 ]; then
    echo "Illegal number of parameters" >> $output_for_logs
    echo $@ >> $output_for_logs
    exit -1
else
    main "$@"
fi
