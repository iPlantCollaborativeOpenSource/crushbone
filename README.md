crushbone
=========

##Atmosphere install, test, configuration, analysis and utility scripts.

Please edit configurationVariables.sh to meet the needs of your installation before running setupAtmosphereEnvironment.sh

######Setting files if you have them, but are not necessary as the script will create them if they are not found

* local.py
* secrets.py
* testing.py

These need to be placed in the root directory or wherever you set the variable LOCATIONOFSETUPFILE to in configurationVariables.sh

######Files needed for SSL Configuration specifically for iPlant:

* iplantc.org.crt
* gd_bundle.crt
* iplantc.key

These need to be placed in the root directory or wherever you set the variable INITIALINSTALLDIRECTORY to in configurationVariables.sh
