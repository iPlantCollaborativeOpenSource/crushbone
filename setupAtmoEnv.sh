#!/bin/bash -x

################################
# Install initial prequisites
################################

source ./configurationVariables.sh

add-apt-repository -y ppa:chris-lea/node.js
apt-get update
apt-get install -y python-pip libffi-dev python-software-properties python g++ make postgresql-9.1 postgresql-server-dev-9.1 libpq-dev python-dev libldap2-dev libsasl2-dev python-m2crypto swig redis-server libssl-dev git nodejs > installLogs

#Don't remove sleep or hash -r.
sleep 3
pip install --upgrade pip
hash -r

echo -e "\n" >> installLogs

################################
# Setup Postgres
################################

service postgresql restart
su postgres -c 'cd ~' 2>> installLogs
su postgres -c 'psql -c "CREATE DATABASE '$DBNAME';"' 2>> installLogs
su postgres -c 'psql -c "CREATE USER '$DBUSER' WITH PASSWORD '\'''$DBPASSWORD''\'' NOSUPERUSER CREATEROLE CREATEDB;"' 2>> installLogs
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
which pip
pip install --upgrade virtualenv 2>> installLogs

mkdir -p $VIRTUAL_ENV
if [ ! -f $VIRTUAL_ENV/bin/activate ]; then
   virtualenv $VIRTUAL_ENV 2>> installLogs
fi

source $VIRTUAL_ENV/bin/activate 2>> installLogs
pip install pip==1.4.1

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

git clone https://github.com/iPlantCollaborativeOpenSource/atmosphere.git $LOCATIONOFATMOSPHERE
cd $LOCATIONOFATMOSPHERE

if [ -f $LOCATIONOFSETUPFILE/local.py ]; then
   cp $LOCATIONOFSETUPFILE/local.py atmosphere/settings/local.py 2>> installLogs
else
   cp atmosphere/settings/local.py.dist atmosphere/settings/local.py 2>> installLogs
   SETTINGSNAME='"NAME": ""'
   NEWSETTINGSNAME="\"NAME\": \"$DBNAME\""
   SETTINGSUSER='"USER": ""'
   NEWSETTINGSUSER="\"USER\": \"$DBUSER\""
   SETTINGSPASSWORD='"PASSWORD": ""'
   NEWSETTINGSPASSWORD="\"PASSWORD\": \"$DBPASSWORD\""
   SETTINGSHOST='"HOST": ""'
   NEWSETTINGSHOST="\"HOST\": \"localhost\""
   SETTINGSPORT='"PORT": ""'
   NEWSETTINGSPORT="\"PORT\": \"5432\""

   ### Search and replace
   sed -i "s/$SETTINGSNAME/$NEWSETTINGSNAME/g" atmosphere/settings/local.py 2>> installLogs
   sed -i "s/$SETTINGSUSER/$NEWSETTINGSUSER/g" atmosphere/settings/local.py 2>> installLogs
   sed -i "s/$SETTINGSPASSWORD/$NEWSETTINGSPASSWORD/g" atmosphere/settings/local.py 2>> installLogs
   sed -i "s/$SETTINGSHOST/$NEWSETTINGSHOST/g" atmosphere/settings/local.py 2>> installLogs
   sed -i "s/$SETTINGSPORT/$NEWSETTINGSPORT/g" atmosphere/settings/local.py 2>> installLogs
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

##This must match the key word in /extras/apache/atmo.conf.dist
MYHOSTNAMEHERE="MYHOSTNAMEHERE"
LOCATIONOFATMOSPHEREHERE="LOCATIONOFATMOSPHEREHERE"

apt-get install -y apache2 libapache2-mod-auth-cas libapache2-mod-wsgi 2>> installLogs
a2enmod rewrite ssl proxy proxy_http auth_cas wsgi 2>> installLogs

cp $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf.dist $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> installLogs

# change url references in atmo.conf

sed -i "s|VIRTUALENVHERE|$VIRTUAL_ENV|g" $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> installLogs
sed -i "s/$MYHOSTNAMEHERE/$SERVERNAME/g" $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> installLogs
sed -i "s|$LOCATIONOFATMOSPHEREHERE|$LOCATIONOFATMOSPHERE|g" $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> installLogs

#Assuming this is not a production box, turn off rewrite rules

RewriteCond="RewriteCond"
ToggleOffRewriteCond="#$RewriteCond"
RewriteRule="RewriteRule"
ToggleOffRewriteRule="#$RewriteRule"

sed -i "s/$RewriteCond/$ToggleOffRewriteCond/g" $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> installLogs
sed -i "s/$RewriteRule/$ToggleOffRewriteRule/g" $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> installLogs


ln -s $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf /etc/apache2/sites-available/atmo.conf
ln -s $LOCATIONOFATMOSPHERE/extras/apache/auth_cas.conf /etc/apache2/sites-available/auth_cas.conf
ln -s $LOCATIONOFATMOSPHERE/extras/apache/shell.conf /etc/apache2/sites-available/shell.conf
ln -s $LOCATIONOFATMOSPHERE/extras/apache/leaderboard.conf /etc/apache2/sites-available/leaderboard.conf

a2dissite 000-default 2>> installLogs
a2ensite atmo.conf auth_cas.conf shell.conf leaderboard.conf 2>> installLogs

chown www-data:www-data $LOCATIONOFATMOSPHERE/logs/atmosphere.log 2>> installLogs
chown www-data:www-data $LOCATIONOFATMOSPHERE/resources/ 2>> installLogs

echo "ServerName $SERVERNAME" >> /etc/apache2/apache2.conf 

################################
# Setup SSL Configuration
################################


## Text to be added to atmo.conf regarding setting up ssl

if [ -f $INITIALINSTALLDIRECTORY/$NAMEOFYOURSSLCERTIFICATE ] && [ -f $INITIALINSTALLDIRECTORY/$NAMEOFYOURSSLBUNDLECERTIFICATE ] && [ -f $INITIALINSTALLDIRECTORY/$NAMEOFYOURSSLKEY ]; then
   cp "$INITIALINSTALLDIRECTORY/$NAMEOFYOURSSLCERTIFICATE" /etc/ssl/certs/ 2>> installLogs
   cp "$INITIALINSTALLDIRECTORY/$NAMEOFYOURSSLBUNDLECERTIFICATE" /etc/ssl/certs/ 2>> installLogs
   cp "$INITIALINSTALLDIRECTORY/$NAMEOFYOURSSLKEY" /etc/ssl/private/ 2>> installLogs

   sed -i "s/BASECERTHERE/$NAMEOFYOURSSLCERTIFICATE/g" $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> installLogs
   sed -i "s/KEYHERE/$NAMEOFYOURSSLKEY/g" $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> installLogs
   sed -i "s/BUNDLECERTHERE/$NAMEOFYOURSSLBUNDLECERTIFICATE/g" $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> installLogs
   echo "Text Replace" >> installLogs
else
    echo "IMPORTANT: PLESE NOTE" >> installLogs
    echo "Either your certificates are incorrect, missing, or you have none" >> installLogs
fi



################################
# Setup SSH Keys
################################
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

service apache2 restart
