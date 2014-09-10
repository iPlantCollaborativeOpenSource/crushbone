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

  ################################
  # Setup Apache Configuration
  ################################

  ##This must match the key word in /extras/apache/atmo.conf.dist
  MYHOSTNAMEHERE="MYHOSTNAMEHERE"
  LOCATIONOFATMOSPHEREHERE="LOCATIONOFATMOSPHERE"
  LOCATIONOFTROPOSPHEREHERE="LOCATIONOFTROPOSPHERE"

  a2enmod rewrite ssl proxy proxy_http auth_cas wsgi macro 2>> $output_for_logs
  /etc/init.d/apache2 restart

  cp $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf.dist $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> $output_for_logs

  # change url references in atmo.conf

  sed -i "s|VIRTUAL_ENV_ATMOSPHERE|$VIRTUAL_ENV_ATMOSPHERE|g" $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> $output_for_logs
  sed -i "s|VIRTUAL_ENV_TROPOSHERE|$VIRTUAL_ENV_TROPOSHERE|g" $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> $output_for_logs

  sed -i "s/$MYHOSTNAMEHERE/$SERVERNAME/g" $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> $output_for_logs
  sed -i "s|$LOCATIONOFATMOSPHEREHERE|$LOCATIONOFATMOSPHERE|g" $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> $output_for_logs
  sed -i "s|$LOCATIONOFTROPOSPHEREHERE|$LOCATIONOFTROPOSPHERE|g" $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> $output_for_logs

  #Assuming this is not a production box, turn off rewrite rules

  RewriteCond="RewriteCond"
  ToggleOffRewriteCond="#$RewriteCond"
  RewriteRule="RewriteRule"
  ToggleOffRewriteRule="#$RewriteRule"

  sed -i "s/$RewriteCond/$ToggleOffRewriteCond/g" $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> $output_for_logs
  sed -i "s/$RewriteRule/$ToggleOffRewriteRule/g" $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> $output_for_logs


  ln -s $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf /etc/apache2/sites-available/atmo.conf
  ln -s $LOCATIONOFATMOSPHERE/extras/apache/auth_cas.conf /etc/apache2/sites-available/auth_cas.conf
  ln -s $LOCATIONOFATMOSPHERE/extras/apache/shell.conf /etc/apache2/sites-available/shell.conf
  ln -s $LOCATIONOFATMOSPHERE/extras/apache/leaderboard.conf /etc/apache2/sites-available/leaderboard.conf

  a2dissite 000-default 2>> $output_for_logs
  a2ensite atmo.conf auth_cas.conf shell.conf leaderboard.conf 2>> $output_for_logs

  chown www-data:www-data $LOCATIONOFATMOSPHERE/logs/atmosphere.log 2>> $output_for_logs
  chown www-data:www-data $LOCATIONOFATMOSPHERE/resources/ 2>> $output_for_logs

  echo "ServerName $SERVERNAME" >> /etc/apache2/apache2.conf
}

if [ "$#" -ne 2 ]; then
  echo "Illegal number of parameters" 2>> $output_for_logs 
  echo $@ 2> $output_for_logs
  exit -1
else
  #EXECUTION
  main $@
fi
