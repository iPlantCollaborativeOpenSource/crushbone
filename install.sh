#!/bin/bash
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
echo "               -E   --virtualenv=      Override environment dir in configuration file"
echo "               -s   --server_name=     Override server name in configuration file"
echo "               --setup_files_dir=      Set the directory containing setup files"
echo "               --ssh_key_dir=          Set the directory containing ssh key-related files"
echo "               --db_name=              Set the database name to be used on installation"
echo "               --db_user=              Set the database user to be used on installation" 
echo "               --db_pass=              Set the database password to be used on installation"
echo ""
if [ "$1" != "" ]; then
echo "USAGE ERROR: $1"
fi
exit
}

_swap_variables() {
    atmo_only=${atmo_only:-false}
    tropo_only=${tropo_only:-false}
    test_only=${test_only:-false}

    db_name=${db_name:-${DBNAME:-"atmo_prod"}}
    db_user=${db_user:-${DBUSER:-"atmo_app"}}
    db_pass=${db_pass:-${DBPASS:-"atmosphere"}}

    branch_name=${branch_name:-${BRANCH_NAME:-"master"}}
    server_name=${server_name:-${SERVERNAME:-"localhost"}}
    working_dir=${working_dir:-${WORKSPACE:-"/opt/dev"}}
    virtualenv_dir=${virtualenv_dir:-${VIRTUALENV:-"/opt/env"}}

    setup_files_dir=${setup_files_dir:-${LOCATIONOFSETUPFILE:-"/root"}}
    ssh_key_dir=${ssh_key_dir:-${SSH_KEY_DIR:-"/root"}}
}

_derived_variables() {
    #Variables for Atmosphere
    atmo_working_dir="$working_dir/atmosphere"
    atmo_logs_dir="$atmo_working_dir/logs"
    atmo_virtualenv="$virtualenv_dir/atmo"
    atmo_files_dir="$setup_files_dir"

    tropo_working_dir="$working_dir/troposphere"
    tropo_logs_dir="$working_dir/logs"
    tropo_virtualnev="$virtualenv_dir/troposphere"
    tropo_files_dir="$setup_files_dir"

    ssh_keys_storage_dir="$ssh_key_dir/.ssh"
}
main() {

    Options=$@
    OptNum=$#


    ## Source the configuration variables
    mkdir -p logs
    . src/01_configurationVariables.sh

    ## Initialize command line vars
    atmo_only=true
    tropo_only=true
    test_only=false
    
    branch_name=""
    working_dir=""
    virtualenv_dir=""
    ssh_key_dir=""
    setup_files_dir=""
    server_name=""
    
    ## Collect command line vars
    while getopts ':atT-b:D:E:s:' OPTION ; do
      case "$OPTION" in
        a  ) tropo_only=false          ;;
        b  ) branch_name="$OPTARG"     ;;
        D  ) working_dir="$OPTARG"     ;;
        E  ) virtualenv_dir="$OPTARG"  ;;
        h  ) _usage                    ;;   
        s  ) server_name="$OPTARG"     ;;
        t  ) atmo_only=false           ;;
        T  ) test_only=true            ;;
        -  ) [ $OPTIND -ge 1 ] && optind=$(expr $OPTIND - 1 ) || optind=$OPTIND
             eval OPTION="\$$optind"
             OPTARG=$(echo $OPTION | cut -d'=' -f2)
             OPTION=$(echo $OPTION | cut -d'=' -f1)
             case $OPTION in
                 --atmosphere_only ) tropo_only=false          ;;
                 --branch ) branch_name="$OPTARG"              ;; 
                 --working_dir ) working_dir="$OPTARG"         ;; 
                 --ssh_key_dir ) ssh_key_dir="$OPTARG"         ;; 
                 --setup_files_dir ) setup_files_dir="$OPTARG" ;; 
                 --virtualenv ) virtualenv_dir="$OPTARG"       ;; 
                 --help ) _usage                               ;;
                 --server_name ) server_name="$OPTARG"         ;; 
                 --troposphere_only ) atmo_only=false          ;;
                 --test ) test_only=true                       ;;
                 --db_user ) db_user="$OPTARG"                 ;;
                 --db_name ) db_name="$OPTARG"                 ;;
                 --db_pass ) db_pass="$OPTARG"                 ;;
                 * )  _usage " Unknown long option provided: $OPTION:$OPTARG" ;;
             esac
           OPTIND=1
           shift
          ;;
        ? )  _usage " Unknown short option provided: $OPTION:$OPTARG" ;;
      esac
    done
    echo $branch_name
    _swap_variables
    _derived_variables
    echo $branch_name
    
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
}

run_steps() {
    #./src/02_dependencies.sh
    #./src/03_pip_install.sh

    ## Override them with arguments
    if $atmo_only; then
      echo "These commands will be run when Atmosphere should be installed"
      #./src/04_postgres.sh $db_name $db_user $db_pass
      #./src/05_setuptools.sh
      #. ./src/06_atmo_virtual_env.sh $atmo_virtualenv
      #./src/07_atmo_git_clone.sh $atmo_working_dir $branch_name
      #./src/08_atmo_setup.sh $setup_files_dir $atmo_working_dir $atmo_logs_dir $atmo_virtualenv $server_name $db_name $db_user $db_pass
      #./src/09_pip_install_atmo_requirements.sh $atmo_working_dir $atmo_virtualenv
      #./src/10_atmo_python_db_migrations.sh $atmo_working_dir $atmo_virtualenv 
      #. src/atmo_virtual_env_deactivate.sh
  
      
      ./src/11_apache_configuration.sh $atmo_working_dir $atmo_virtualenv $tropo_working_dir $server_name
      ./src/12_ssl_configuration.sh $atmo_working_dir $ssh_key_dir
    fi
    
    if $tropo_only; then
        echo "These commands will be run when Troposphere should be installed"
    fi
    
    if $test_only; then
        echo "These commands will be run when Chromogenic is creating a test build"
    fi

    #. src/ssh_keys.sh
    #. src/start_atmosphere.sh
    #. src/troposphere_virtual_env.sh
    #. src/troposphere_setup.sh
}


#EXECUTION PATH:
main $@
run_steps
