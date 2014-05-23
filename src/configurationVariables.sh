#!/bin/bash -x

# TODO Be sure to change this!
SERVERNAME="SERVERNAMEHERE"

#Variables for Postgres. Recommended names
DBNAME=atmo_prod
DBUSER=atmo_app
DBPASSWORD=atmosphere

#Variables for Virtualenv
VIRTUAL_ENV_ATMOSPHERE="/opt/env/atmo"

#Variables for Atmosphere
LOCATIONOFATMOSPHERE="/opt/dev/atmosphere"
LOCATIONOFLOGS="$LOCATIONOFATMOSPHERE/logs"

#Variables for Trophosphere
LOCATIONOFTROPOSPHERE="/opt/dev/troposphere"
VIRTUAL_ENV_TROPOSHERE="/opt/env/troposphere" 

#Variables for configuration
#This specifies the location of configuration files(e.g. local.py, secrets.py, testing.py)
LOCATIONOFSETUPFILE="/root"

#Variables for SSL Configuration

INITIALINSTALLDIRECTORY="/root"
NAMEOFYOURSSLCERTIFICATE="iplantc.org.crt"
NAMEOFYOURSSLKEY="iplantc.key"
NAMEOFYOURSSLBUNDLECERTIFICATE="gd_bundle.crt"

#Variables for SSH Key Configuration

LOCATIONOFPERSONALKEYS="/root/.ssh"


