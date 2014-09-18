#!/bin/bash -x

##############################
# Usage
#
#  LOCATIONOFSETUPFILE - $1
#  LOCATIONOFATMOSPHERE - $2
#  LOCATIONOFLOGS - $3
#  VIRTUAL_ENV_ATMOSPHERE - $4
#  SERVERNAME - $5
#  DBNAME - $6
#  DBUSER - $7
#  DBPASSWORD - $8
# 
##############################

this_filename=$(basename $BASH_SOURCE)
output_for_logs="logs/$this_filename.log"
touch $output_for_logs

main(){

  if [ "$#" -ne 8 ]; then
    echo "Illegal number of parameters" 2>> $output_for_logs
    echo $@ 2> $output_for_logs
    exit -1
  fi

  ## Initialize command line vars
  LOCATIONOFSETUPFILE=$1
  LOCATIONOFATMOSPHERE=$2
  LOCATIONOFLOGS=$3
  VIRTUAL_ENV_ATMOSPHERE=$4
  SERVERNAME=$5
  DBNAME=$6
  DBUSER=$7
  DBPASSWORD=$8

}

run_steps(){
  ####################################
  # Initial Atmosphere Setup
  ####################################


  if [ -e $LOCATIONOFSETUPFILE/local.py ]; then
    echo "Command: cp $LOCATIONOFSETUPFILE/local.py $LOCATIONOFATMOSPHERE/atmosphere/settings/local.py" >> $output_for_logs
    cp $LOCATIONOFSETUPFILE/local.py $LOCATIONOFATMOSPHERE/atmosphere/settings/local.py 2>> $output_for_logs;
    #FIXME: .iplantc.org --> FQDN
    sed -i "s/SERVERNAME/$SERVERNAME.iplantc.org/g" $LOCATIONOFATMOSPHERE/atmosphere/settings/local.py 2>> $output_for_logs
  else

    echo "$LOCATIONOFSETUPFILE/local.py does not exist" >> $output_for_logs
    echo "Command: cp $LOCATIONOFATMOSPHERE/atmosphere/settings/local.py.dist $LOCATIONOFATMOSPHERE/atmosphere/settings/local.py" >> $output_for_logs;
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
    echo "Command: cp $LOCATIONOFSETUPFILE/secrets.py $LOCATIONOFATMOSPHERE/atmosphere/settings/secrets.py" >> $output_for_logs    
    cp $LOCATIONOFSETUPFILE/secrets.py $LOCATIONOFATMOSPHERE/atmosphere/settings/secrets.py 2>> $output_for_logs
  else
    echo "$LOCATIONOFSETUPFILE/secrets.py does not exist" >> $output_for_logs
    echo "Command: cp $LOCATIONOFATMOSPHERE/atmosphere/settings/secrets.py.dist $LOCATIONOFATMOSPHERE/atmosphere/settings/secrets.py" >> $output_for_logs
    cp $LOCATIONOFATMOSPHERE/atmosphere/settings/secrets.py.dist $LOCATIONOFATMOSPHERE/atmosphere/settings/secrets.py 2>> $output_for_logs
  fi

  if [ -e $LOCATIONOFSETUPFILE/testing.py ]; then
    echo "Command: cp $LOCATIONOFSETUPFILE/testing.py $LOCATIONOFATMOSPHERE/atmosphere/settings/testing.py" >> $output_for_logs
    cp $LOCATIONOFSETUPFILE/testing.py $LOCATIONOFATMOSPHERE/atmosphere/settings/testing.py 2>> $output_for_logs
  else
    echo "$LOCATIONOFSETUPFILE/testing.py does not exist" >> $output_for_logs
    echo "cp $LOCATIONOFATMOSPHERE/atmosphere/settings/testing.py.dist $LOCATIONOFATMOSPHERE/atmosphere/settings/testing.py" >> $output_for_logs
    cp $LOCATIONOFATMOSPHERE/atmosphere/settings/testing.py.dist $LOCATIONOFATMOSPHERE/atmosphere/settings/testing.py 2>> $output_for_logs
  fi

  
  mkdir -p $LOCATIONOFATMOSPHERE/extras/ssh/

  if [ -e $LOCATIONOFSETUPFILE/id_rsa ]; then
    echo "Command: cp $LOCATIONOFSETUPFILE/id_rsa $LOCATIONOFATMOSPHERE/extras/ssh/" >> $output_for_logs
    cp $LOCATIONOFSETUPFILE/id_rsa $LOCATIONOFATMOSPHERE/extras/ssh/ 2>> $output_for_logs
  else
    echo "NOTICE:id_rsa does not exist and may cause scripts to fail down the way!" >> $output_for_logs
  fi


  if [ -e $LOCATIONOFSETUPFILE/id_rsa.pub ]; then
    echo "Command: cp $LOCATIONOFSETUPFILE/id_rsa.pub $LOCATIONOFATMOSPHERE/extras/ssh/" >> $output_for_logs
    cp $LOCATIONOFSETUPFILE/id_rsa.pub $LOCATIONOFATMOSPHERE/extras/ssh/ 2>> $output_for_logs 
  else
    echo "NOTICE:id_rsa.pub does not exist and may cause scripts to fail down the way!" >> $output_for_logs
  fi

  mkdir -p $LOCATIONOFLOGS
  if [ ! -e $LOCATIONOFLOGS/atmosphere.log ]; then
    touch $LOCATIONOFLOGS/atmosphere.log
    touch $LOCATIONOFLOGS/atmosphere_status.log
  else
    echo "Atmosphere.log already exists" >> $output_for_logs 
  fi
  
  #
  # PLEASE NOTE: This will only work if this line is in the wsgi.py file
  # "sys.path.insert(1, root_dir)"


  insertBeforeThisLine="sys.path.insert(1, root_dir)"
  insertNewLine="sys.path.insert(0, '$VIRTUAL_ENV_ATMOSPHERE/lib/python2.7/site-packages/')"
  sed -i "/.*$insertBeforeThisLine.*/i$insertNewLine" $LOCATIONOFATMOSPHERE/atmosphere/wsgi.py 2>> $output_for_logs
 


  ##This must match the key word in atmosphere/settings/__init__.py
  MYHOSTNAMEHERE="MYHOSTNAMEHERE"  #Wise not to change -A.M.
  echo "Command: sed -i "s/$MYHOSTNAME_HERE/$SERVERNAME/g" $LOCATIONOFATMOSPHERE/atmosphere/settings/__init__.py" >> $output_for_logs
  sed -i "s/$MYHOSTNAMEHERE/$SERVERNAME/g" $LOCATIONOFATMOSPHERE/atmosphere/settings/__init__.py 2>> $output_for_logs

  # TODO
  # Check to see if user and group exists
  chown -R www-data:www-data $LOCATIONOFATMOSPHERE 2>> $output_for_logs
}

#EXECUTION PATH:
main $@
run_steps
