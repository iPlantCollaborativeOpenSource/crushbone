#!/bin/bash -x


this_filename=$(basename $BASH_SOURCE)
output_for_logs="logs/$this_filename.log"

####################################
# Initial Atmosphere Setup
####################################


touch $output_for_logs

if [ -e $LOCATIONOFSETUPFILE/local.py ]; then
   cp $LOCATIONOFSETUPFILE/local.py $LOCATIONOFATMOSPHERE/atmosphere/settings/local.py 2>> $output_for_logs;
else
   cp $LOCATIONOFATMOSPHERE/atmosphere/settings/local.py.dist $LOCATIONOFATMOSPHERE/atmosphere/settings/local.py 2>> $output_for_logs;
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
   sed -i "s/$SETTINGSNAME/$NEWSETTINGSNAME/g" $LOCATIONOFATMOSPHERE/atmosphere/settings/local.py 2>> $output_for_logs
   sed -i "s/$SETTINGSUSER/$NEWSETTINGSUSER/g" $LOCATIONOFATMOSPHERE/atmosphere/settings/local.py 2>> $output_for_logs
   sed -i "s/$SETTINGSPASSWORD/$NEWSETTINGSPASSWORD/g" $LOCATIONOFATMOSPHERE/atmosphere/settings/local.py 2>> $output_for_logs
   sed -i "s/$SETTINGSHOST/$NEWSETTINGSHOST/g" $LOCATIONOFATMOSPHERE/atmosphere/settings/local.py 2>> $output_for_logs
   sed -i "s/$SETTINGSPORT/$NEWSETTINGSPORT/g" $LOCATIONOFATMOSPHERE/atmosphere/settings/local.py 2>> $output_for_logs
fi

if [ -e $LOCATIONOFSETUPFILE/secrets.py ]; then
   cp $LOCATIONOFSETUPFILE/secrets.py $LOCATIONOFATMOSPHERE/atmosphere/settings/secrets.py 2>> $output_for_logs
else
   cp $LOCATIONOFATMOSPHERE/atmosphere/settings/secrets.py.dist $LOCATIONOFATMOSPHERE/atmosphere/settings/secrets.py 2>> $output_for_logs
fi

if [ -e $LOCATIONOFSETUPFILE/testing.py ]; then
   cp $LOCATIONOFSETUPFILE/testing.py $LOCATIONOFATMOSPHERE/atmosphere/settings/testing.py 2>> $output_for_logs
else
   cp $LOCATIONOFATMOSPHERE/atmosphere/settings/testing.py.dist $LOCATIONOFATMOSPHERE/atmosphere/settings/testing.py 2>> $output_for_logs
fi

mkdir -p $LOCATIONOFLOGS
if [ ! -e $LOCATIONOFLOGS/atmosphere.log ]; then
  touch $LOCATIONOFLOGS/atmosphere.log
fi

#
# PLEASE NOTE: This will only work if this line is in the wsgi.py file
# "sys.path.insert(1, root_dir)"

insertBeforeThisLine="sys.path.insert(1, root_dir)"
insertNewLine="sys.path.insert(0, '$VIRTUAL_ENV_ATMOSPHERE/lib/python2.7/site-packages/')"

sed -i "/.*$insertBeforeThisLine.*/i$insertNewLine" $LOCATIONOFATMOSPHERE/atmosphere/wsgi.py 2>> $output_for_logs

##This must match the key word in atmosphere/settings/__init__.py
MYHOSTNAMEHERE="MYHOSTNAMEHERE"
sed -i "s/$MYHOSTNAMEHERE/$SERVERNAME/g" $LOCATIONOFATMOSPHERE/atmosphere/settings/__init__.py 2>> $output_for_logs

chown -R www-data:core-services $LOCATIONOFATMOSPHERE
