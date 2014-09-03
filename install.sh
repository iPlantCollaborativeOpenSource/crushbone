#!/bin/bash

Options=$@
OptNum=$#

_usage() {
echo "##### U S A G E : Help and ERROR ######"
echo "$0 $Options"
echo "*"
echo "       Usage: $0 <[options]>"
echo "       Options:"
echo "               -a   --atmosphere_only  Execute crushbone to install Troposphere components ONLY."
echo "               -h   --help             Show this message"
echo "               -t   --troposphere_only Execute crushbone to install Troposphere components ONLY."
echo "               -T   --test             Execute crushbone in 'test' mode. Useful for jenkins"
echo ""
echo "               -b   --branch=          Override git branch name in configuration file"
echo "               -D   --working_dir=     Override source code dir in configuration file"
echo "               -E   --virtualenv=     Override environment dir in configuration file"
echo "               -s   --server_name=     Override server name in configuration file"
echo ""
if [ "$1" != "" ]; then
echo "USAGE ERROR: $1"
fi
}
## Initialize command line vars
atmo_only=false
tropo_only=false
test_only=false

branch_name=""
working_dir=""
virtualenv_dir=""
server_name=""

## Collect command line vars
while getopts ':atT-b:D:E:s:' OPTION ; do
  case "$OPTION" in
    a  ) atmo_only=true           ;;
    b  ) branch_name="$OPTARG"    ;;
    D  ) working_dir="$OPTARG"    ;;
    E  ) virtualenv_dir="$OPTARG" ;;
    h  ) _usage                   ;;   
    s  ) server_name="$OPTARG"    ;;
    t  ) tropo_only=true          ;;
    T  ) test_only=true           ;;
    -  ) [ $OPTIND -ge 1 ] && optind=$(expr $OPTIND - 1 ) || optind=$OPTIND
         eval OPTION="\$$optind"
         OPTARG=$(echo $OPTION | cut -d'=' -f2)
         OPTION=$(echo $OPTION | cut -d'=' -f1)
         case $OPTION in
             --atmosphere_only ) atmosphere_only=true    ;;
             --branch ) branch_name="$OPTARG"            ;; 
             --working_dir ) working_dir="$OPTARG"       ;; 
             --virtualenv ) virtualenv_dir="$OPTARG"     ;; 
             --help ) _usage                             ;;
             --server_name ) server_name="$OPTARG"       ;; 
             --troposphere_only ) troposphere_only=true  ;;
             --test ) test_only=true                     ;;
             * )  _usage " Unknown long option provided: $OPTION:$OPTARG" ;;
         esac
       OPTIND=1
       shift
      ;;
    ? )  _usage " Unknown short option provided: $OPTION:$OPTARG" ;;
  esac
done
echo "---------------------------------------------------"
echo "Your Configuration:"
echo "Atmosphere Only: $atmo_only"
echo "Troposphere Only: $tropo_only"
echo "Test Mode: $test_only"
echo "Branch Name: $branch_name"
echo "Server Name: $server_name"
echo "Source Code Dir: $working_dir"
echo "Environment Dir: $virtualenv_dir"
echo "---------------------------------------------------"
exit 0
## Source the configuration variables

## Override them with arguments

#mkdir logs
#. src/01_configurationVariables.sh
#. src/02_dependencies.sh
#. src/03_pip_install.sh
#. src/04_postgres.sh
#. src/05_setuptools.sh
#. src/06_atmo_virtual_env.sh
##. src/m2cryptoconfiguration.sh
##. src/atmo_setup.sh
##. src/pip_install_atmo_requirements.sh
##. src/atmo_python_db_migrations.sh
##. src/atmo_virtual_env_deactivate.sh
##. src/apache_configuration.sh
##. src/ssl_configuration.sh
##. src/ssh_keys.sh
##. src/start_atmosphere.sh
##. src/troposphere_virtual_env.sh
##. src/troposphere_setup.sh
