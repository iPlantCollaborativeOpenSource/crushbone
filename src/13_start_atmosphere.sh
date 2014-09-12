#!/bin/bash -x

this_filename=$(basename $BASH_SOURCE)
output_for_logs="logs/$this_filename.log" 
touch $output_for_logs

################################
# Run Atmosphere!
################################


service apache2 restart 2>> $output_for_logs
