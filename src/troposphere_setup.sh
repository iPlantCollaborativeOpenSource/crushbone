#!/bin/bash -x

################################
# Setup Troposphere Project
################################

git clone https://github.com/iPlantCollaborativeOpenSource/troposphere.git $LOCATIONOFTROPOSPHERE
cd $LOCATIONOFTROPOSPHERE
pip install --upgrade pip
pip install -r requirements.txt
npm update npm -g
npm install gulp -g
npm install
gem install sass

#Build stuff with glup
gulp


echo "Edit local.py with your own settings. You'll have to generate a new keypair from Groupy for the Troposphere application.\n The configuration variable OAUTH_PRIVATE_KEY_PATH should refer to the absolute path of that key."
