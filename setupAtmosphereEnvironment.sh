#!/bin/bash -x

################################
# Install initial prequisites
################################

apt-get install -y python-pip postgresql-9.1 postgresql-server-dev-9.1 libpq-dev python-dev libldap2-dev libsasl2-dev python-m2crypto swig redis-server libssl-dev git > installLogs
pip install --upgrade pip 

echo -e "\n" >> installLogs

################################
# Setup Postgres
################################

#variables
DBNAME=atmosphere
DBUSER=atmo_app
DBPASSWORD=atmosphere

service postgresql restart
su postgres -c 'cd ~' 2>> installLogs
su postgres -c 'psql -c "CREATE DATABASE '$DBNAME';"' 2>> installLogs
su postgres -c 'psql -c "CREATE USER '$DBUSER' WITH PASSWORD '\'''$DBPASSWORD''\'' NOSUPERUSER NOCREATEROLE NOCREATEDB;"' 2>> installLogs
su postgres -c 'psql -c "REVOKE connect ON DATABASE '$DBNAME' FROM PUBLIC;"' 2>> installLogs
su postgres -c 'psql -c "GRANT connect ON DATABASE '$DBNAME' TO '$DBUSER';"' 2>> installLogs
echo -e "local   all             atmo_app                                md5" >> /etc/postgresql/9.1/main/pg_hba.conf

echo -e "\n" >> installLogs

################################
# Setup Setup-Tools
################################

wget https://pypi.python.org/packages/2.7/s/setuptools/setuptools-0.6c11-py2.7.egg#md5=fe1f997bc722265116870bc7919059ea 2>> installLogs
sh setuptools-0.6c11-py2.7.egg 2>> installLogs

################################
# Setup Virtualenv
################################

#variables
VIRTUAL_ENV="/opt/env/atmo"

pip install virtualenv 2>> installLogs
pip install --upgrade virtualenv 2>> installLogs

mkdir -p $VIRTUAL_ENV
if [ -d $VIRTUAL_ENV ]; then
   virtualenv $VIRTUAL_ENV 2>> installLogs
fi

source /opt/env/atmo/bin/activate 2>> installLogs

################################
# Setup M2CryptoConfiguration
################################

m2crypto_loc=$VIRTUAL_ENV/lib/python2.7/site-packages/M2Crypto
if [ ! -L $m2crypto_loc ]; then
    sudo ln -s /usr/lib/python2.7/dist-packages/M2Crypto $m2crypto_loc 2>> installLogs
fi


################################
# Setup Project
################################
LOCATIONOFATMOSPHERE="/opt/dev/atmosphere"
LOCATIONOFLOGS="logs"

LOCATIONOFSETUPFILE="/root"

git clone https://github.com/iPlantCollaborativeOpenSource/atmosphere.git $LOCATIONOFATMOSPHERE
cd $LOCATIONOFATMOSPHERE

if [ -f $LOCATIONOFSETUPFILE/local.py ]; then
   cp $LOCATIONOFSETUPFILE/local.py atmosphere/settings/local.py 2>> installLogs
else
   cp atmosphere/settings/local.py.dist atmosphere/settings/local.py 2>> installLogs
fi

if [ -f $LOCATIONOFSETUPFILE/secrets.py ]; then
   cp $LOCATIONOFSETUPFILE/secrets.py atmosphere/settings/secrets.py 2>> installLogs
else
   cp atmosphere/settings/secrets.py.dist atmosphere/settings/secrets.py 2>> installLogs
fi

if [ -f $LOCATIONOFSETUPFILE/testing.py ]; then
   cp $LOCATIONOFSETUPFILE/testing.py atmosphere/settings/testing.py 2>> installLogs
else
   cp atmosphere/settings/testing.py.dist atmosphere/settings/testing.py 2>> installLogs
fi


mkdir -p $LOCATIONOFLOGS 
if [ ! -d $LOCATIONSOFLOGS ]; then
  touch $LOCATIONOFLOGS/atmosphere.log
fi

#
# PLEASE NOTE: This will only work if this line is in the wsgi.py file
# "sys.path.insert(1, root_dir)"

insertBeforeThisLine="sys.path.insert(1, root_dir)"
insertNewLine="sys.path.insert(0, '$VIRTUAL_ENV/lib/python2.7/site-packages/')"

sed -i "/.*$insertBeforeThisLine.*/i$insertNewLine" atmosphere/wsgi.py 2>> installLogs


################################
# Setup Python Packages
################################

pip install -r requirements.txt --upgrade 2>> installLogs

python manage.py syncdb 2>> installLogs
python manage.py migrate 2>> installLogs

python manage.py loaddata core/fixtures/provider.json 2>> installLogs
python manage.py loaddata core/fixtures/quota.json 2>> installLogs

export PYTHONPATH=$LOCATIONOFATMOSPHERE
export DJANGO_SETTINGS_MODULE='atmosphere.settings'

#python scripts/import_users_from_euca.py 2>> installLogs
#python scripts/import_users_from_openstack.py 2>> installLogs

python manage.py createcachetable atmosphere_cache_requests 2>> installLogs
python manage.py collectstatic 2>> installLogs

################################
# Setup Apache Configuration
################################
SERVERNAME="vm142-46.iplantc.org"

##This must match the key word in /extras/apache/atmo.conf.dist
MYHOSTNAMEHERE="MYHOSTNAMEHERE"
LOCATIONOFATMOSPHEREHERE="LOCATIONOFATMOSPHEREHERE"

apt-get install -y apache2 libapache2-mod-auth-cas libapache2-mod-wsgi 2>> installLogs
a2enmod rewrite ssl proxy proxy_http auth_cas wsgi 2>> installLogs

cp $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf.dist $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> installLogs

# change url references in atmo.conf

sed -i "s/$MYHOSTNAMEHERE/$SERVERNAME/g" $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> installLogs
sed -i "s|$LOCATIONOFATMOSPHEREHERE|$LOCATIONOFATMOSPHERE|g" $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> installLogs

ln -s $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf /etc/apache2/sites-available/atmo.conf
ln -s $LOCATIONOFATMOSPHERE/extras/apache/auth_cas.conf /etc/apache2/sites-available/auth_cas.conf
ln -s $LOCATIONOFATMOSPHERE/extras/apache/shell.conf /etc/apache2/sites-available/shell.conf
ln -s $LOCATIONOFATMOSPHERE/extras/apache/leaderboard.conf /etc/apache2/sites-available/leaderboard.conf

a2dissite 000-default 2>> installLogs
a2ensite atmo.conf auth_cas.conf shell.conf leaderboard.conf 2>> installLogs

chown www-data:www-data $LOCATIONOFATMOSPHERE/logs/atmosphere.log 2>> installLogs
chown www-data:www-data $LOCATIONOFATMOSPHERE/resources/ 2>> installLogs

SERVERNAME="vm142-46.iplantc.org"
echo "ServerName $SERVERNAME" >> /etc/apache2/apache2.conf 

################################
# Setup SSL Configuration
################################



################################
# Setup SSH Keys
################################
LOCATIONOFPERSONALKEYS="~/.ssh"
LOCATIONOFATMOSPHEREEXTRAKEYS="$LOCATIONOFATMOSPHERE/extras/ssh"

mkdir -p $LOCATIONOFATMOSPHEREEXTRAKEYS

if [ -f $LOCATIONOFPERSONALKEYS/id_rsa ]; then
  ln -s $LOCATIONOFPERSONALKEYS/id_rsa.pub $LOCATIONOFATMOSPHEREEXTRAKEYS/id_rsa.pub 2>> installLogs
  ln -s $LOCATIONOFPERSONALKEYS/id_rsa $LOCATIONOFATMOSPHEREEXTRAKEYS/id_rsa 2>> installLogs
else
  ssh-keygen -f "$LOCATIONOFATMOSPHEREEXTRAKEYS/id_rsa" -t rsa -N '' 2>> installLogs
fi

################################
# Run Atmosphere!
################################

#service apache2 restart
