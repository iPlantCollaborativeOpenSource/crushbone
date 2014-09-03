#!/bin/bash -x

this_filename=$(basename $BASH_SOURCE)
output_for_logs="logs/$this_filename.log"
touch $output_for_logs
####################################
# Git clone setups
####################################

if [ ! $BRANCH_NAME = "" ]; then
   git clone -b $BRANCH_NAME https://github.com/iPlantCollaborativeOpenSource/atmosphere.git $LOCATIONOFATMOSPHERE 2>> $output_for_logs
else
   git clone https://github.com/iPlantCollaborativeOpenSource/atmosphere.git $LOCATIONOFATMOSPHERE 2>> $output_for_logs
fi
