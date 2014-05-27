crushbone
=========

##Atmosphere install, test, configuration, analysis and utility scripts.

Please edit src/configurationVariables.sh to meet the needs of your installation before running install.sh

######Atmosphere configuration files if you have them, but are not necessary as the script will create them if they are not found

* local.py
* secrets.py
* testing.py

These need to be placed in the root directory or wherever you set the variable LOCATIONOFSETUPFILE to in src/configurationVariables.sh

######Files needed for SSL Configuration specifically for iPlant:

* iplantc.org.crt
* gd_bundle.crt
* iplantc.key

These need to be placed in the root directory or wherever you set the variable INITIALINSTALLDIRECTORY to in src/configurationVariables.sh

######Files needed for SSH keys Configuration

These files need to be placed in the root directory or wherever you set the variable LOCATIONOFPERSONALKEYS to in src/configurationVariables.sh

######Files needed for Troposphere Configuration

* local.py

These files need to be placed in the root directory or wherever you set the variable LOCATIONOFTROPOSPHERELOCALFILE to in src/configurationVariables.sh
