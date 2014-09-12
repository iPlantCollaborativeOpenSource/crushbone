#!/bin/bash -x

##############################
# Usage
#
# LOCATIONOFATMOSPHERE - $1
# VIRTUAL_ENV_ATMOSPHERE - $2
# LOCATIONOFTROPOSPHERE - $3 
# SERVERNAME - $4
##############################


this_filename=$(basename $BASH_SOURCE)
output_for_logs="logs/$this_filename.log"

touch $output_for_logs



main(){

  LOCATIONOFATMOSPHERE=$1
  VIRTUAL_ENV_ATMOSPHERE=$2
  LOCATIONOFTROPOSPHERE=$3
  SERVERNAME=$4
  #NOTE: These are passed as ENVIRONMENT VARIABLES!
  # See: src/01_configurationVariables.sh
  #NAMEOFYOURSSLCERTIFICATE=$4
  #NAMEOFYOURSSLKEY=$5
  #NAMEOFYOURSSLBUNDLECERTIFICATE=$6

  ################################
  # Setup Apache Configuration
  ################################

  #Download appropriate modules, copy the dist, add the macro
  a2enmod rewrite ssl proxy proxy_http auth_cas wsgi macro 2>> $output_for_logs
  /etc/init.d/apache2 restart
  cp $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf.dist $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> $output_for_logs
  echo "Use Atmosphere $SERVERNAME $LOCATIONOFATMOSPHERE $LOCATIONOFTROPOSPHERE $NAMEOFYOURSSLCERTIFICATE $NAMEOFYOURSSLKEY $NAMEOFYOURSSLBUNDLECERTIFICATE" >> $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> $output_for_logs

  #Symlink all extras files to appropriate space in apache so that future
  #updates are applied automatically
  ln -s $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf /etc/apache2/sites-available/atmo.conf 2>> $output_for_logs
  ln -s $LOCATIONOFATMOSPHERE/extras/apache/auth_cas.conf /etc/apache2/sites-available/auth_cas.conf 2>> $output_for_logs
  ln -s $LOCATIONOFATMOSPHERE/extras/apache/shell.conf /etc/apache2/sites-available/shell.conf 2>> $output_for_logs
  ln -s $LOCATIONOFATMOSPHERE/extras/apache/leaderboard.conf /etc/apache2/sites-available/leaderboard.conf 2>> $output_for_logs

  a2dissite 000-default 2>> $output_for_logs
  a2ensite atmo.conf auth_cas.conf shell.conf leaderboard.conf 2>> $output_for_logs

  chown www-data:www-data $LOCATIONOFATMOSPHERE/logs/atmosphere.log 2>> $output_for_logs
  chown www-data:www-data $LOCATIONOFATMOSPHERE/resources/ 2>> $output_for_logs

  echo "ServerName $SERVERNAME" >> /etc/apache2/apache2.conf
}

if [ "$#" -ne 4 ]; then
  echo "Illegal number of parameters" 2>> $output_for_logs 
  echo $@ 2> $output_for_logs
  exit -1
else
  #EXECUTION
  main $@
fi

