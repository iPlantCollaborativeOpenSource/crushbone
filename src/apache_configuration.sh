#!/bin/bash -x

################################
# Setup Apache Configuration
################################

##This must match the key word in /extras/apache/atmo.conf.dist
MYHOSTNAMEHERE="MYHOSTNAMEHERE"
LOCATIONOFATMOSPHEREHERE="LOCATIONOFATMOSPHEREHERE"
LOCATIONOFTROPOSPHEREHERE="LOCATIONOFTROPOSPHERE"

apt-get install -y apache2 libapache2-mod-auth-cas libapache2-mod-wsgi 2>> logs/install.error
a2enmod rewrite ssl proxy proxy_http auth_cas wsgi 2>> logs/install.error

cp $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf.dist $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> logs/install.error

# change url references in atmo.conf

sed -i "s|VIRTUAL_ENV_ATMOSPHERE|$VIRTUAL_ENV_ATMOSPHERE|g" $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> logs/install.error
sed -i "s|VIRTUAL_ENV_TROPOSHERE|$VIRTUAL_ENV_TROPOSHERE|g" $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> logs/install.error

sed -i "s/$MYHOSTNAMEHERE/$SERVERNAME/g" $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> logs/install.error
sed -i "s|$LOCATIONOFATMOSPHEREHERE|$LOCATIONOFATMOSPHERE|g" $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> logs/install.error
sed -i "s|$LOCATIONOFTROPOSPHEREHERE|$LOCATIONOFTROPOSPHERE|g" $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> logs/install.error

#Assuming this is not a production box, turn off rewrite rules

RewriteCond="RewriteCond"
ToggleOffRewriteCond="#$RewriteCond"
RewriteRule="RewriteRule"
ToggleOffRewriteRule="#$RewriteRule"

sed -i "s/$RewriteCond/$ToggleOffRewriteCond/g" $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> logs/install.error
sed -i "s/$RewriteRule/$ToggleOffRewriteRule/g" $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> logs/install.error


ln -s $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf /etc/apache2/sites-available/atmo.conf
ln -s $LOCATIONOFATMOSPHERE/extras/apache/auth_cas.conf /etc/apache2/sites-available/auth_cas.conf
ln -s $LOCATIONOFATMOSPHERE/extras/apache/shell.conf /etc/apache2/sites-available/shell.conf
ln -s $LOCATIONOFATMOSPHERE/extras/apache/leaderboard.conf /etc/apache2/sites-available/leaderboard.conf

a2dissite 000-default 2>> logs/install.error
a2ensite atmo.conf auth_cas.conf shell.conf leaderboard.conf 2>> logs/install.error

chown www-data:www-data $LOCATIONOFATMOSPHERE/logs/atmosphere.log 2>> logs/install.error
chown www-data:www-data $LOCATIONOFATMOSPHERE/resources/ 2>> logs/install.error

echo "ServerName $SERVERNAME" >> /etc/apache2/apache2.conf
