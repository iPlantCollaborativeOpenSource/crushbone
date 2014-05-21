#!/bin/bash -x

################################
# Setup SSH Keys
################################
LOCATIONOFATMOSPHEREEXTRAKEYS="$LOCATIONOFATMOSPHERE/extras/ssh"

mkdir -p $LOCATIONOFATMOSPHEREEXTRAKEYS

if [ -f $LOCATIONOFPERSONALKEYS/id_rsa ]; then
  ln -s $LOCATIONOFPERSONALKEYS/id_rsa.pub $LOCATIONOFATMOSPHEREEXTRAKEYS/id_rsa.pub 2>> logs/install.error
  ln -s $LOCATIONOFPERSONALKEYS/id_rsa $LOCATIONOFATMOSPHEREEXTRAKEYS/id_rsa 2>> logs/install.error
else
  ssh-keygen -f "$LOCATIONOFATMOSPHEREEXTRAKEYS/id_rsa" -t rsa -N '' 2>> logs/install.error
fi
