#!/bin/bash -x
PS4='$(date "+%s.%N ($LINENO) + ")'

###
#
# Configuration Variables: Set these BEFORE executing install.sh!
#
###

#SERVER NAME
# Sets your server name in Apache and Django.
#SERVERNAME="localhost"

#BRANCH NAME
# Select the branch of atmosphere/troposphere to pull down and build
#BRANCH_NAME="master"

#WORKING DIRECTORY
# The Directory and environment directory to build the project(s)
#WORKSPACE="/opt/dev"
#VIRTUALENV="/opt/env"

#DB Variables
# Set the Database Name, User, & Password
#DBNAME="atmo_prod"
#DBUSER="atmo_app"
#DBPASSWORD="atmosphere"

#Variables for configuration
#This specifies the location of configuration files(e.g. local.py, secrets.py, testing.py)
#LOCATIONOFSETUPFILE="/root"

#Variables for SSL Configuration
#SSH Directory
# This directory should contain the three files listed below, to enable HTTPS
# security on Atmosphere/Troposphere:
#SSH_KEY_DIR="/root"

export NAMEOFYOURSSLCERTIFICATE="iplantc.org.crt"
export NAMEOFYOURSSLKEY="iplantc.key"
export NAMEOFYOURSSLBUNDLECERTIFICATE="gd_bundle.crt"

##Variables for SSH Key Configuration
#
#LOCATIONOFPERSONALKEYS="$SSH_KEY_DIR/.ssh"
#
#LOCATIONOFTROPOSPHERELOCALFILE="$SSH_KEY_DIR"
#LOCATIONOFTROPOSPHEREKEY="$SSH_KEY_DIR"
