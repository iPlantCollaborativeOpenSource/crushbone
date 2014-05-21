#!/bin/bash -x

################################
# Setup SSL Configuration
################################


## Text to be added to atmo.conf regarding setting up ssl

if [ -f $INITIALINSTALLDIRECTORY/$NAMEOFYOURSSLCERTIFICATE ] && [ -f $INITIALINSTALLDIRECTORY/$NAMEOFYOURSSLBUNDLECERTIFICATE ] && [ -f $INITIALINSTALLDIRECTORY/$NAMEOFYOURSSLKEY ]; then
   cp "$INITIALINSTALLDIRECTORY/$NAMEOFYOURSSLCERTIFICATE" /etc/ssl/certs/ 2>> logs/install.error
   cp "$INITIALINSTALLDIRECTORY/$NAMEOFYOURSSLBUNDLECERTIFICATE" /etc/ssl/certs/ 2>> logs/install.error
   cp "$INITIALINSTALLDIRECTORY/$NAMEOFYOURSSLKEY" /etc/ssl/private/ 2>> logs/install.error

   sed -i "s/BASECERTHERE/$NAMEOFYOURSSLCERTIFICATE/g" $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> logs/install.error
   sed -i "s/KEYHERE/$NAMEOFYOURSSLKEY/g" $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> logs/install.error
   sed -i "s/BUNDLECERTHERE/$NAMEOFYOURSSLBUNDLECERTIFICATE/g" $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> logs/install.error
   echo "Text Replace" >> logs/install.error
else
    echo "IMPORTANT: PLESE NOTE" >> logs/install.error
    echo "Either your certificates are incorrect, missing, or you have none" >> logs/install.error
fi
