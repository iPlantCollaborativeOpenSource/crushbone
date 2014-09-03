#!/bin/bash -x

###
#
# Configuration Variables: Set these BEFORE executing install.sh!
#
###

SERVERNAME="myserver"

#BRANCH NAME
# This is allowed to be blank, or you can specify a branch and crushbone will pull it down
BRANCH_NAME="mybranch"

#Variables for Postgres. Recommended names
DBNAME="atmo_prod"
DBUSER="atmo_app"
DBPASSWORD="atmosphere"

#Variables for Virtualenv
WORKSPACE="myspace"
VIRTUALENV="myenv"

#Variables for Atmosphere
LOCATIONOFATMOSPHERE="$WORKSPACE/atmosphere"
VIRTUAL_ENV_ATMOSPHERE="$VIRTUALENV/atmo"
LOCATIONOFLOGS="$LOCATIONOFATMOSPHERE/logs"

#Variables for Trophosphere
LOCATIONOFTROPOSPHERE="$WORKSPACE/troposphere"
VIRTUAL_ENV_ATMOSPHERE="$VIRTUALENV/troposphere"

#Variables for configuration
#This specifies the location of configuration files(e.g. local.py, secrets.py, testing.py)
LOCATIONOFSETUPFILE="/root"

#Variables for SSL Configuration

INITIALINSTALLDIRECTORY="/root"
NAMEOFYOURSSLCERTIFICATE="iplantc.org.crt"
NAMEOFYOURSSLKEY="iplantc.key"
NAMEOFYOURSSLBUNDLECERTIFICATE="gd_bundle.crt"

#Variables for SSH Key Configuration

LOCATIONOFPERSONALKEYS="$INITIALINSTALLDIRECTORY/.ssh"

LOCATIONOFTROPOSPHERELOCALFILE="$INITIALINSTALLDIRECTORY"
LOCATIONOFTROPOSPHEREKEY="$INITIALINSTALLDIRECTORY"
