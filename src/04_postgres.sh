#!/bin/bash -x
PS4='$(date "+%s.%N ($LINENO) + ")'

##############################
# Usage
#
# Required Arguments
# 
# $1 - DBNAME
# $2 - DBUSER
# $3 - DBPASSWORD
###############################

this_filename=$(basename $BASH_SOURCE)
output_for_logs="logs/$this_filename.log" 


main(){

  DBNAME=$1
  DBUSER=$2
  DBPASSWORD=$3

  ################################
  # Setup Postgres
  ################################
  grep -r 'local[ ]*all[ ]*atmo_app[ ]*md5' /etc/postgresql/9.*/main
  if [ "$?" = "1" ]; then
      su postgres -c 'cd' 2> $output_for_logs
      su postgres -c 'psql -c "CREATE DATABASE '$DBNAME';"' 2>> $output_for_logs 
      su postgres -c 'psql -c "CREATE USER '$DBUSER' WITH PASSWORD '\'''$DBPASSWORD''\'' NOSUPERUSER CREATEROLE CREATEDB;"' 2>> $output_for_logs 
      su postgres -c 'psql -c "REVOKE connect ON DATABASE '$DBNAME' FROM PUBLIC;"' 2>> $output_for_logs 
      su postgres -c 'psql -c "GRANT connect ON DATABASE '$DBNAME' TO '$DBUSER';"' 2>> $output_for_logs 
      echo -e "local   all             atmo_app                                md5" >> /etc/postgresql/9.1/main/pg_hba.conf 
      service postgresql restart
  fi

}


# Execution Thread

if [ "$#" -ne 3 ]; then
  echo "Illegal number of parameters" 2> $output_for_logs
  exit -1
else
  main "$@"
fi
