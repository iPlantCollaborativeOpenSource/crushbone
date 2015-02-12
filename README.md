crushbone
=========

##Atmosphere and Troposphere install, test, configuration, and  utility scripts.

Its a good idea to walk through the install.sh script and read what is going on. This script assumes a clean install on a barebones machine.

######Atmosphere configuration 

If you have them, but are not necessary as the script will create them if they are not found

* local.py
* secrets.py

These need to be placed in a directory (for example, lets call it crushbone_initial_setting_files). Perferably at the root directory. You will pass in this directory location into the install script when the script is called.

######Troposphere configuration files

If you have them, but are not necessary as the script will create them if they are not found.

* local.py

This file needs to be placed in a directory called "tropo". This tropo directory should be placed in the directory along side the atmosphere files.

######Files needed for SSL Configuration:

* A organizational cert
* A bundle cert
* And a organization ssl key

These files also need to be placed in directory also with the other files. Please set the variables to the names of the certs in src/0_1configurationVariables.sh

######Files needed for SSH keys Configuration

* A private id_rsa file
* A publice id_rsa file


These files also need to be placed in directory also with the other files. 

#####Run Crushbone

Your file structure with all the collected files should look like this:

crushbone_initial_setting_files
+-- _local.py
+-- _secrets.py
+-- _id_rsa
+-- _id_rsa.pub
+-- _gd_bundle.crt
+-- _organization.crt
+-- _organization.key
+-- _tropo
|   +-- local.py 

If you do not have these files, you are welcome to create the directories and just have them empty and replace the files later and run crushbone again at a later time. For example:

crushbone_initial_setting_files
+-- _tropo

To run crushbone's help prompt
```
install.sh -h
```

Assuming you are following along in naming convention to run crushbone and want a basic install:
```
./install.sh --setup_files_dir=/root/crushbone_initial_setting_files --ssh_key_dir=/root/crushbone_initial_setting_files --server_name=<fully_qualified_hostname_here>
```

Example:
```
/install.sh --setup_files_dir=/root/crushbone_initial_setting_files --ssh_key_dir=/root│/crushbone_initial_setting_files --server_name=atmo.iplantcollaborative.org
```

To pull in a particular branch of atmosphere
```
./install.sh --branch=<branch_name_here> --setup_files_dir=/root/crushbone_initial_setting_files --ssh_key_dir=/root/crushbone_initial_setting_files --server_name=<fully_qualified_hostname_here>
```

Example:

```
./install.sh  --branch=abyssinian-nightjar --setup_files_dir=/root/crushbone_initial_setting_files --ssh_key_dir=/root/crushbone_initial_setting_files --server_name=atmo.iplantcollaborative.org
```


There is a vast amount of options you can pass in, but I recommend getting a base install first before adding options.

If you did not pass in any files to crushbone, go and edit the newly created files in (/opt/dev/atmosphere/atmosphere/settings and /opt/dev/troposphere/troposphere/settings assuming a base default install).


Upon a successful/failed run, it is best to step through the logs dir in the crushbone directory and see what output has been produced. Most output does not indicate a failed run. In addition, visiting the apache ssl error logs (often found in /var/log/apache2/ssl_error.log) are great source of information as to what is causing the errors when visiting 

Further revisions to crushbone are on the way so be sure to check back often.

Good luck. 
