#!/bin/bash -x

################################
# Setup SSL Configuration
################################


## Text to be added to atmo.conf regarding setting up ssl

if [ -f $INITIALINSTALLDIRECTORY/$NAMEOFYOURSSLCERTIFICATE ] && [ -f $INITIALINSTALLDIRECTORY/$NAMEOFYOURSSLBUNDLECERTIFICATE ] && [ -f $INITIALINSTALLDIRECTORY/$NAMEOFYOURSSLKEY ]; then
   cp "$INITIALINSTALLDIRECTORY/$NAMEOFYOURSSLCERTIFICATE" /etc/ssl/certs/ 2>> install.log
   cp "$INITIALINSTALLDIRECTORY/$NAMEOFYOURSSLBUNDLECERTIFICATE" /etc/ssl/certs/ 2>> install.log
   cp "$INITIALINSTALLDIRECTORY/$NAMEOFYOURSSLKEY" /etc/ssl/private/ 2>> install.log

   sed -i "s/BASECERTHERE/$NAMEOFYOURSSLCERTIFICATE/g" $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> install.log
   sed -i "s/KEYHERE/$NAMEOFYOURSSLKEY/g" $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> install.log
   sed -i "s/BUNDLECERTHERE/$NAMEOFYOURSSLBUNDLECERTIFICATE/g" $LOCATIONOFATMOSPHERE/extras/apache/atmo.conf 2>> install.log
else
    echo "IMPORTANT: PLESE NOTE" >> install.log
    echo "Either your certificates are incorrect, missing, or you have none" >> install.log
fi
