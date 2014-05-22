#!/bin/bash -x

################################
# Setup SSH Keys
################################
LOCATIONOFATMOSPHEREEXTRAKEYS="$LOCATIONOFATMOSPHERE/extras/ssh"

mkdir -p $LOCATIONOFATMOSPHEREEXTRAKEYS

if [ -f $LOCATIONOFPERSONALKEYS/id_rsa ]; then
  ln -s $LOCATIONOFPERSONALKEYS/id_rsa.pub $LOCATIONOFATMOSPHEREEXTRAKEYS/id_rsa.pub 2>> install.log
  ln -s $LOCATIONOFPERSONALKEYS/id_rsa $LOCATIONOFATMOSPHEREEXTRAKEYS/id_rsa 2>> install.log
  echo "ssh keys were moved to $LOCATIONOFATMOSPHEREEXTRAKEYS/id_rsa" >> install.log
else
  ssh-keygen -f "$LOCATIONOFATMOSPHEREEXTRAKEYS/id_rsa" -t rsa -N '' 2>> install.log
  echo "ssh keys were generated to $LOCATIONOFATMOSPHEREEXTRAKEYS/id_rsa" >> install.log
fi
