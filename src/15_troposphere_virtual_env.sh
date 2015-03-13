#!/bin/bash -x
PS4='$(date "+%s.%N ($LINENO) + ")'

################################
# Usage
#
# VIRTUAL_ENV_TROPOSHERE - $1
################################

################################
# Setup troposphere
################################

this_filename=$(basename $BASH_SOURCE)
output_for_logs="logs/$this_filename.log"

touch $output_for_logs

main(){

  VIRTUAL_ENV_TROPOSHERE=$1

  mkdir -p "$VIRTUAL_ENV_TROPOSHERE"
  if [ ! -f "$VIRTUAL_ENV_TROPOSHERE/bin/activate" ]; then
    virtualenv "$VIRTUAL_ENV_TROPOSHERE" 2>> $output_for_logs
  fi

  source "$VIRTUAL_ENV_TROPOSHERE/bin/activate" 2>> $output_for_logs
}

if [ "$#" -ne 1 ]; then
  echo "Illegal number of parameters" 2>> $output_for_logs
  echo $@ 2> $output_for_logs
  exit -1
else
  #EXECUTION
  main "$@"
fi
