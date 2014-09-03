#!/bin/bash -x

this_filename=$(basename $BASH_SOURCE)
output_for_logs="logs/$this_filename.log"
################################
# Setup Postgres
################################

service postgresql restart
su postgres -c 'cd' 2> $output_for_logs
su postgres -c 'psql -c "CREATE DATABASE '$DBNAME';"' 2>> $output_for_logs 
su postgres -c 'psql -c "CREATE USER '$DBUSER' WITH PASSWORD '\'''$DBPASSWORD''\'' NOSUPERUSER CREATEROLE CREATEDB;"' 2>> $output_for_logs 
su postgres -c 'psql -c "REVOKE connect ON DATABASE '$DBNAME' FROM PUBLIC;"' 2>> $output_for_logs 
su postgres -c 'psql -c "GRANT connect ON DATABASE '$DBNAME' TO '$DBUSER';"' 2>> $output_for_logs 
echo -e "local   all             atmo_app                                md5" >> /etc/postgresql/9.1/main/pg_hba.conf 
