#!/bin/bash -x

git clone https://github.com/iPlantCollaborativeOpenSource/atmosphere.git $LOCATIONOFATMOSPHERE
cd $LOCATIONOFATMOSPHERE

if [ -f $LOCATIONOFSETUPFILE/local.py ]; then
   cp $LOCATIONOFSETUPFILE/local.py atmosphere/settings/local.py 2>> logs/install.error
else
   cp atmosphere/settings/local.py.dist atmosphere/settings/local.py 2>> logs/install.error
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
   sed -i "s/$SETTINGSNAME/$NEWSETTINGSNAME/g" atmosphere/settings/local.py 2>> logs/install.error
   sed -i "s/$SETTINGSUSER/$NEWSETTINGSUSER/g" atmosphere/settings/local.py 2>> logs/install.error
   sed -i "s/$SETTINGSPASSWORD/$NEWSETTINGSPASSWORD/g" atmosphere/settings/local.py 2>> logs/install.error
   sed -i "s/$SETTINGSHOST/$NEWSETTINGSHOST/g" atmosphere/settings/local.py 2>> logs/install.error
   sed -i "s/$SETTINGSPORT/$NEWSETTINGSPORT/g" atmosphere/settings/local.py 2>> logs/install.error
fi

if [ -f $LOCATIONOFSETUPFILE/secrets.py ]; then
   cp $LOCATIONOFSETUPFILE/secrets.py atmosphere/settings/secrets.py 2>> logs/install.error
else
   cp atmosphere/settings/secrets.py.dist atmosphere/settings/secrets.py 2>> logs/install.error
fi

if [ -f $LOCATIONOFSETUPFILE/testing.py ]; then
   cp $LOCATIONOFSETUPFILE/testing.py atmosphere/settings/testing.py 2>> logs/install.error
else
   cp atmosphere/settings/testing.py.dist atmosphere/settings/testing.py 2>> logs/install.error
fi

mkdir -p $LOCATIONOFLOGS
if [ ! -d $LOCATIONSOFLOGS ]; then
  touch $LOCATIONOFLOGS/atmosphere.log
fi

#
# PLEASE NOTE: This will only work if this line is in the wsgi.py file
# "sys.path.insert(1, root_dir)"

insertBeforeThisLine="sys.path.insert(1, root_dir)"
insertNewLine="sys.path.insert(0, '$VIRTUAL_ENV_ATMOSPHERE/lib/python2.7/site-packages/')"

sed -i "/.*$insertBeforeThisLine.*/i$insertNewLine" atmosphere/wsgi.py 2>> logs/install.error

