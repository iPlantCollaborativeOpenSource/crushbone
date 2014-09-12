#!/bin/bash -x

##############################
# Usage
#
# LOCATIONOFATMOSPHERE - $1
# INITIALINSTALLDIRECTORY - $2
# NAMEOFYOURSSLCERTIFICATE - $3
# NAMEOFYOURSSLBUNDLECERTIFICATE - $4
# $NAMEOFYOURSSLKEY - $5
##############################

this_filename=$(basename $BASH_SOURCE)
output_for_logs="logs/$this_filename.log"
touch $output_for_logs

main(){

  LOCATIONOFATMOSPHERE=$1
  INITIALINSTALLDIRECTORY=$2
  #NOTE: These are passed as ENVIRONMENT VARIABLES!
  # See: src/01_configurationVariables.sh
  #NAMEOFYOURSSLCERTIFICATE=$3
  #NAMEOFYOURSSLKEY=$4
  #NAMEOFYOURSSLBUNDLECERTIFICATE=$5
  
  ################################
  # Setup SSL Configuration
  ################################


  ## Text to be added to atmo.conf regarding setting up ssl

  if [ -f "$INITIALINSTALLDIRECTORY/$NAMEOFYOURSSLCERTIFICATE" ] && [ -f "$INITIALINSTALLDIRECTORY/$NAMEOFYOURSSLBUNDLECERTIFICATE" ] && [ -f "$INITIALINSTALLDIRECTORY/$NAMEOFYOURSSLKEY" ]; then
    cp "$INITIALINSTALLDIRECTORY/$NAMEOFYOURSSLCERTIFICATE" /etc/ssl/certs/ 2>> $output_for_logs
    cp "$INITIALINSTALLDIRECTORY/$NAMEOFYOURSSLBUNDLECERTIFICATE" /etc/ssl/certs/ 2>> $output_for_logs
    cp "$INITIALINSTALLDIRECTORY/$NAMEOFYOURSSLKEY" /etc/ssl/private/ 2>> $output_for_logs

  else
    echo "IMPORTANT: PLESE NOTE" >> $output_for_logs
    echo "Either your certificates are incorrect, missing, or you have none" >> $output_for_logs
  fi
}

if [ "$#" -ne 2 ]; then
  echo "Illegal number of parameters" 2>> $output_for_logs
  echo $@ 2> $output_for_logs
  exit -1
else
  #EXECUTION
  main $@
fi



