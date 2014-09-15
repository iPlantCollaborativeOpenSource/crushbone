#!/bin/bash -x

##############################
# Usage
#
# LOCATIONOFATMOSPHERE - $1
##############################

this_filename=$(basename $BASH_SOURCE)
output_for_logs="logs/$this_filename.log" 
touch $output_for_logs 

main(){
  
  LOCATIONOFATMOSPHERE=$1
  
  if [ ! -e "/etc/ufw/applications.d/celery" ]; then
    echo "[Celery]" > /etc/ufw/applications.d/celery
    echo "title=Remote Celery Communications" >> /etc/ufw/applications.d/celery
    echo "description=Enables remote celery connections" >> /etc/ufw/applications.d/celery
    echo "ports=6379/tcp" >> /etc/ufw/applications.d/celery
  fi

  ufw allow "Apache Full"
  ufw allow Celery
  
  if [ ! -e "/etc/init.d/celeryd" ]; then
    ln -s $LOCATIONOFATMOSPHERE/extras/init.d/ubuntu.celeryd /etc/init.d/celeryd
    ln -s $LOCATIONOFATMOSPHERE/extras/init.d/ubuntu.celerybeat /etc/init.d/celerybeat
  fi

  if [ ! -e "$LOCATIONOFATMOSPHERE/extras/init.d/celeryd.default" ]; then
    cp $LOCATIONOFATMOSPHERE/extras/init.d/celeryd.default.dist $LOCATIONOFATMOSPHERE/extras/init.d/celeryd.default
    ln -s /opt/dev/atmosphere/extras/init.d/celeryd.default /etc/default/celeryd
  fi

  if [ ! -e "/etc/init.d/atmosphere" ]; then
    ln -s $LOCATIONOFATMOSPHERE/extras/init.d/atmosphere /etc/init.d/atmosphere
  fi 
  service atmosphere celery-restart 2>> $output_for_logs
}

if [ "$#" -ne 1 ]; then
  echo "Illegal number of parameters" 2>> $output_for_logs
  echo $@ 2> $output_for_logs
  exit -1
else
  #EXECUTION
  main $@
fi
