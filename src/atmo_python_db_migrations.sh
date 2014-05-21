#!/bin/bash -x

################################
# Setup Python Packages
################################

pip install -r requirements.txt --upgrade 2>> logs/install.error

python manage.py syncdb 2>> logs/install.error
python manage.py migrate 2>> logs/install.error

python manage.py loaddata core/fixtures/provider.json 2>> logs/install.error
python manage.py loaddata core/fixtures/quota.json 2>> logs/install.error

export PYTHONPATH=$LOCATIONOFATMOSPHERE
export DJANGO_SETTINGS_MODULE='atmosphere.settings'

#python scripts/import_users_from_euca.py 2>> logs/install.error
#python scripts/import_users_from_openstack.py 2>> logs/install.error

python manage.py createcachetable atmosphere_cache_requests 2>> logs/install.error
python manage.py collectstatic 2>> logs/install.error
