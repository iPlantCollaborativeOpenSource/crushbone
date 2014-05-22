#!/bin/bash -x

################################
# Setup Postgres
################################

service postgresql restart
su postgres -c 'cd' 2>> install.log
su postgres -c 'psql -c "CREATE DATABASE '$DBNAME';"' 2>> install.log
su postgres -c 'psql -c "CREATE USER '$DBUSER' WITH PASSWORD '\'''$DBPASSWORD''\'' NOSUPERUSER CREATEROLE CREATEDB;"' 2>> install.log
su postgres -c 'psql -c "REVOKE connect ON DATABASE '$DBNAME' FROM PUBLIC;"' 2>> install.log
su postgres -c 'psql -c "GRANT connect ON DATABASE '$DBNAME' TO '$DBUSER';"' 2>> install.log
echo -e "local   all             atmo_app                                md5" >> /etc/postgresql/9.1/main/pg_hba.conf

echo -e "\n" >> install.log
