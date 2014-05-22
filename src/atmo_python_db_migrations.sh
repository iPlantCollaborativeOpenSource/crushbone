#!/bin/bash -x

################################
# Setup Python Packages
################################
export PYTHONPATH=$LOCATIONOFATMOSPHERE
export DJANGO_SETTINGS_MODULE='atmosphere.settings'


#####################
## Install yuglify
#####################
npm -g install yuglify

python $LOCATIONOFATMOSPHERE/manage.py syncdb 2>> install.log
python $LOCATIONOFATMOSPHERE/manage.py migrate 2>> install.log

python $LOCATIONOFATMOSPHERE/manage.py loaddata $LOCATIONOFATMOSPHERE/core/fixtures/provider.json 2>> install.log
python $LOCATIONOFATMOSPHERE/manage.py loaddata $LOCATIONOFATMOSPHERE/core/fixtures/quota.json 2>> install.log

python $LOCATIONOFATMOSPHERE/manage.py createcachetable atmosphere_cache_requests 2>> install.log
python $LOCATIONOFATMOSPHERE/manage.py collectstatic --noinput 2>> install.log
python $LOCATIONOFATMOSPHERE/scripts/import_users_from_openstack.py 2>> install.log


###########
#EUCA STUFF
##########
#python scripts/import_users_from_euca.py 2>> install.log
