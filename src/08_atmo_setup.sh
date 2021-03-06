#!/bin/bash -x
PS4='$(date "+%s.%N ($LINENO) + ")'

##############################
# Usage
#
#  LOCATIONOFSETUPFILE - $1
#  LOCATIONOFATMOSPHERE - $2
#  LOCATIONOFLOGS - $3
#  VIRTUAL_ENV_ATMOSPHERE - $4
#  SERVERNAME - $5
#  DBNAME - $6
#  DBUSER - $7
#  DBPASSWORD - $8
# 
##############################

this_filename=$(basename $BASH_SOURCE)
output_for_logs="logs/$this_filename.log"
touch $output_for_logs

main(){

  if [ "$#" -ne 8 ]; then
    echo "Illegal number of parameters" 2>> $output_for_logs
    echo $@ 2> $output_for_logs
    exit -1
  fi

  ## Initialize command line vars
  LOCATIONOFSETUPFILE=$1
  LOCATIONOFATMOSPHERE=$2
  LOCATIONOFLOGS=$3
  VIRTUAL_ENV_ATMOSPHERE=$4
  SERVERNAME=$5
  DBNAME=$6
  DBUSER=$7
  DBPASSWORD=$8

}

run_steps(){
  ####################################
  # Initial Atmosphere Setup
  ####################################


  echo "Command: cp $LOCATIONOFSETUPFILE/variables.ini $LOCATIONOFATMOSPHERE/variables.ini" >> $output_for_logs
  cp "$LOCATIONOFSETUPFILE/variables.ini" "$LOCATIONOFATMOSPHERE/variables.ini" 2>> $output_for_logs;
  echo "Command: s/SERVERNAME/$SERVERNAME/g" >> $output_for_logs
  sed -i "s/SERVERNAME/$SERVERNAME/g" "$LOCATIONOFATMOSPHERE/variables.ini" 2>> $output_for_logs

  #Need jinja2 -- Install the requirements!
  source "$VIRTUAL_ENV_ATMOSPHERE/bin/activate" 2>> $output_for_logs
  $VIRTUAL_ENV_ATMOSPHERE/bin/pip install -r $LOCATIONOFATMOSPHERE/dev_requirements.txt 2>> $output_for_logs

  # Build config scripts
  BASEDIRECTORY=`pwd`
  cd "$LOCATIONOFATMOSPHERE"
  ./scripts/generate_configs.py  # This is true for builds pre-Jamming
  ./configure  # Use this for builds post-jamming junglefowl

  #GO back!
  cd "$BASEDIRECTORY"

  mkdir -p "$LOCATIONOFATMOSPHERE/extras/ssh/"

  if [ -e "$LOCATIONOFSETUPFILE/id_rsa" ]; then
    echo "Command: cp $LOCATIONOFSETUPFILE/id_rsa $LOCATIONOFATMOSPHERE/extras/ssh/" >> $output_for_logs
    cp "$LOCATIONOFSETUPFILE/id_rsa" "$LOCATIONOFATMOSPHERE/extras/ssh/" 2>> $output_for_logs
  else
    echo "NOTICE:id_rsa does not exist and may cause scripts to fail down the way!" >> $output_for_logs
  fi


  if [ -e "$LOCATIONOFSETUPFILE/id_rsa.pub" ]; then
    echo "Command: cp $LOCATIONOFSETUPFILE/id_rsa.pub $LOCATIONOFATMOSPHERE/extras/ssh/" >> $output_for_logs
    cp "$LOCATIONOFSETUPFILE/id_rsa.pub" "$LOCATIONOFATMOSPHERE/extras/ssh/" 2>> $output_for_logs 
  else
    echo "NOTICE:id_rsa.pub does not exist and may cause scripts to fail down the way!" >> $output_for_logs
  fi

  mkdir -p "$LOCATIONOFLOGS"
  if [ ! -e "$LOCATIONOFLOGS/atmosphere.log" ]; then
    touch "$LOCATIONOFLOGS/atmosphere.log"
    touch "$LOCATIONOFLOGS/atmosphere_status.log"
  else
    echo "Atmosphere.log already exists" >> $output_for_logs 
  fi
  
  #
  # PLEASE NOTE: This will only work if this line is in the wsgi.py file
  # "sys.path.insert(1, root_dir)"


  insertBeforeThisLine="sys.path.insert(1, root_dir)"
  insertNewLine="sys.path.insert(0, '$VIRTUAL_ENV_ATMOSPHERE/lib/python2.7/site-packages/')"
  sed -i "/.*$insertBeforeThisLine.*/i$insertNewLine" "$LOCATIONOFATMOSPHERE/atmosphere/wsgi.py" 2>> $output_for_logs
 


  ##This must match the key word in atmosphere/settings/__init__.py
  #NOTE: We actually want to leave the __init__ alone
  #MYHOSTNAMEHERE="MYHOSTNAMEHERE"  #Wise not to change -A.M.
  #echo "Command: sed -i "s/$MYHOSTNAME_HERE/$SERVERNAME/g" $LOCATIONOFATMOSPHERE/atmosphere/settings/__init__.py" >> $output_for_logs
  #sed -i "s/$MYHOSTNAMEHERE/$SERVERNAME/g" $LOCATIONOFATMOSPHERE/atmosphere/settings/__init__.py 2>> $output_for_logs

  # TODO
  # Check to see if user and group exists
  chown -R www-data:www-data "$LOCATIONOFATMOSPHERE" 2>> $output_for_logs
}

#EXECUTION PATH:
main "$@"
run_steps
