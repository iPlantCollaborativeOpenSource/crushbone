#!/bin/bash -x

# TODO Be sure to change this!
SERVERNAME="example.host.com"


#Variables for Postgres. Recommended names
DBNAME=atmosphere
DBUSER=atmo_app
DBPASSWORD=atmosphere

#Variables for Virtualenv
VIRTUAL_ENV="/opt/env/atmo"

#Variables for Atmosphere
LOCATIONOFATMOSPHERE="/opt/dev/atmosphere"
LOCATIONOFLOGS="logs"

#Variables for configuration
#This specifies the location of configuration files(e.g. local.py, secrets.py, testing.py)
LOCATIONOFSETUPFILE="/root"

#Variables for SSL Configuration

INITIALINSTALLDIRECTORY="/root"
NAMEOFYOURSSLCERTIFICATE="iplantc.org.crt"
NAMEOFYOURSSLKEY="iplantc.key"
NAMEOFYOURSSLBUNDLECERTIFICATE="gd_bundle.crt"

#Variables for SSH Key Configuration

LOCATIONOFPERSONALKEYS="~/.ssh"


