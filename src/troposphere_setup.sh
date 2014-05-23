#!/bin/bash -x

################################
# Setup Troposphere Project
################################

git clone https://github.com/iPlantCollaborativeOpenSource/troposphere.git $LOCATIONOFTROPOSPHERE
pip install --upgrade pip 2>> install.log
pip install -r $LOCATIONOFTROPOSPHERE/requirements.txt 2>> install.log

if [ -e $LOCATIONOFTROPOSPHERELOCALFILE/local.py ]; then
  cp $LOCATIONOFTROPOSPHERELOCALFILE/local.py $LOCATIONOFTROPOSPHERE/troposphere/settings/local.py 2>> install.log;
else
  cp $LOCATIONOFTROPOSPHERE/troposphere/settings/local.py.dist $LOCATIONOFTROPOSPHERE/troposphere/settings/local.py
fi

npm update npm -g 2>> install.log
npm install gulp -g 2>> install.log
gem install sass 2>> install.log
BASEDIRECTORY=`pwd`
cd $LOCATIONOFTROPOSPHERE
npm install 2>> install.log

#Build stuff with glup
gulp 2>> install.log
cd $BASEDIRECTORY

echo "Edit $LOCATIONOFTROPOSPHERE/troposphere/settings/local.py with your own settings. You'll have to generate a new keypair from Groupy for the Troposphere application.\n The configuration variable OAUTH_PRIVATE_KEY_PATH should refer to the absolute path of that key."
