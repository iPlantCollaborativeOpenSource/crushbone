#!/bin/bash -x

##############################
# Usage
#
# $LOCATIONOFATMOSPHERE - $1
# $VIRTUAL_ENV_ATMOSPHERE - $2
##############################


this_filename=$(basename $BASH_SOURCE)
output_for_logs="logs/$this_filename.log"
touch $output_for_logs


main(){

  LOCATIONOFATMOSPHERE=$1
  VIRTUAL_ENV_ATMOSPHERE=$2 
  ################################
  # Setup Python Packages
  ################################

  export PYTHONPATH=$LOCATIONOFATMOSPHERE
  export DJANGO_SETTINGS_MODULE='atmosphere.settings'


  #####################
  ## Install yuglify
  #####################
  npm -g install yuglify

  $VIRTUAL_ENV_ATMOSPHERE/bin/python $LOCATIONOFATMOSPHERE/manage.py syncdb 2>> $output_for_logs
  $VIRTUAL_ENV_ATMOSPHERE/bin/python $LOCATIONOFATMOSPHERE/manage.py migrate 2>> $output_for_logs

  $VIRTUAL_ENV_ATMOSPHERE/bin/python $LOCATIONOFATMOSPHERE/manage.py loaddata $LOCATIONOFATMOSPHERE/core/fixtures/provider.json 2>> $output_for_logs
  $VIRTUAL_ENV_ATMOSPHERE/bin/python $LOCATIONOFATMOSPHERE/manage.py loaddata $LOCATIONOFATMOSPHERE/core/fixtures/quota.json 2>> $output_for_logs

  $VIRTUAL_ENV_ATMOSPHERE/bin/python $LOCATIONOFATMOSPHERE/manage.py createcachetable atmosphere_cache_requests 2>> $output_for_logs
  $VIRTUAL_ENV_ATMOSPHERE/bin/python $LOCATIONOFATMOSPHERE/manage.py collectstatic --noinput 2>> $output_for_logs
  
  # TODO 
  # Fix import users section
  #$VIRTUAL_ENV_ATMOSPHERE/bin/python $LOCATIONOFATMOSPHERE/scripts/import_users_from_openstack.py 2>> $output_for_logs


  ###########
  #EUCA STUFF
  ##########
  #python scripts/import_users_from_euca.py 2>> $output_for_logs
}
if [ "$#" -ne 2 ]; then
  echo "Illegal number of parameters" 2>> $output_for_logs
  echo $@ 2> $output_for_logs
  exit -1
else
  #EXECUTION
  main $@
fi
