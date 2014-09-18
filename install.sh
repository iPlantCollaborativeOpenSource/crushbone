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
    install_atmo=${install_atmo:-false}
    install_tropo=${install_tropo:-false}
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
    tropo_virtualenv="$virtualenv_dir/troposphere"
    tropo_files_dir="$setup_files_dir/tropo"

    ssh_keys_storage_dir="$ssh_key_dir/.ssh"
}
main() {

    Options=$@
    OptNum=$#


    ## Source the configuration variables
    mkdir -p logs
    . src/01_configurationVariables.sh

    ## Initialize command line vars
    install_atmo=true
    install_tropo=true
    test_only=false
    jenkins=false

    branch_name=""
    working_dir=""
    virtualenv_dir=""
    ssh_key_dir=""
    setup_files_dir=""
    server_name=""

    ## Collect command line vars
    while getopts ':atT-b:D:E:s:' OPTION ; do
      case "$OPTION" in
        a  ) install_tropo=false          ;;
        b  ) branch_name="$OPTARG"     ;;
        D  ) working_dir="$OPTARG"     ;;
        E  ) virtualenv_dir="$OPTARG"  ;;
        h  ) _usage                    ;;
        j  ) jenkins=true              ;;
        s  ) server_name="$OPTARG"     ;;
        t  ) install_atmo=false           ;;
        T  ) test_only=true            ;;
        -  ) [ $OPTIND -ge 1 ] && optind=$(expr $OPTIND - 1 ) || optind=$OPTIND
             eval OPTION="\$$optind"
             OPTARG=$(echo $OPTION | cut -d'=' -f2)
             OPTION=$(echo $OPTION | cut -d'=' -f1)
             case $OPTION in
                 --atmosphere_only ) install_tropo=false          ;;
                 --branch ) branch_name="$OPTARG"              ;;
                 --jenkins) jenkins=true                       ;;
                 --working_dir ) working_dir="$OPTARG"         ;;
                 --ssh_key_dir ) ssh_key_dir="$OPTARG"         ;;
                 --setup_files_dir ) setup_files_dir="$OPTARG" ;;
                 --virtualenv ) virtualenv_dir="$OPTARG"       ;;
                 --help ) _usage                               ;;
                 --server_name ) server_name="$OPTARG"         ;;
                 --troposphere_only ) install_atmo=false          ;;
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
    echo "Jenkins Rebuild: $jenkins"
    echo "Test Mode: $test_only"
    echo "Install Atmosphere: $install_atmo"
    echo "Install Troposphere: $install_tropo"
    echo "Branch Name: $branch_name"
    echo "Server Name: $server_name"
    echo "Source Code Dir: $working_dir"
    echo "Environment Dir: $virtualenv_dir"
    echo "---------------------------------------------------"
    echo -n "Ctrl+C to exit and change your configuration...3..."
    sleep 1
    echo -n "2..."
    sleep 1
    echo -n "1..."
    sleep 1
    echo "Executing build."
}
install_dependencies() {
    ./src/02_dependencies.sh
    ./src/03_pip_install.sh
}
build_troposphere() {
    echo "These commands will be run when Troposphere should be installed"
    . src/15_troposphere_virtual_env.sh $tropo_virtualenv
    . src/16_troposphere_setup.sh $tropo_working_dir $tropo_files_dir $server_name
    . src/14_virtual_env_deactivate.sh
}
build_atmosphere() {
    echo "These commands will be run when Atmosphere should be installed"
    ./src/04_postgres.sh $db_name $db_user $db_pass
    ./src/05_setuptools.sh
    . ./src/06_atmo_virtual_env.sh $atmo_virtualenv
    ./src/07_atmo_git_clone.sh $atmo_working_dir $branch_name
    ./src/08_atmo_setup.sh $setup_files_dir $atmo_working_dir $atmo_logs_dir $atmo_virtualenv $server_name $db_name $db_user $db_pass
    ./src/09_pip_install_atmo_requirements.sh $atmo_working_dir $atmo_virtualenv
    ./src/10_atmo_python_db_migrations.sh $atmo_working_dir $atmo_virtualenv
    . src/14_virtual_env_deactivate.sh
}
build_production_server() {
      ./src/11_apache_configuration.sh $atmo_working_dir $atmo_virtualenv $tropo_working_dir $server_name
      ./src/12_ssl_configuration.sh $atmo_working_dir $ssh_key_dir
      ./src/13_start_atmosphere.sh "apache"
      ./src/17_celery_setup.sh $atmo_working_dir
      ./src/13_start_atmosphere.sh "atmosphere"
}
atmo_rebuild_jenkins() {
    #Jenkins already has postgresql setup properly
    #Jenkins already has atmosphere cloned in the correct workspace
    . ./src/06_atmo_virtual_env.sh $atmo_virtualenv
    #Jenkins already has the correct atmosphere settings, no overwrites
    #required
    ./src/09_pip_install_atmo_requirements.sh $atmo_working_dir $atmo_virtualenv
    ./src/10_atmo_python_db_migrations.sh $atmo_working_dir $atmo_virtualenv
    #Jenkins already has the correct apache settings, no overwrites
    #required
    . src/14_virtual_env_deactivate.sh
    ./src/17_celery_setup.sh $atmo_working_dir
    ./src/13_start_atmosphere.sh "atmosphere"
}
tropo_rebuild_jenkins() {
    #TODO: Find out if we need to do anything special here..
    build_troposphere
}
run_steps() {
    #NOTE: The dependencies could be split out for tropo/atmo later on..
    #FIXME: Using . relative paths will lead to issues finding correct paths
    #       when executed outside of the 'crushbone' directory.
    #FIXME: instead of exit 0 we should track $? for non-zero and always bubble
    #       up non-zero when they are encountered so jenkins/script knows a
    #       non-standard install occurred..
    #install_dependencies

    if [[ "$jenkins" = "true" && "$install_atmo" = "true" ]]; then
        echo "Rebuilding Jenkins on Atmosphere"
        atmo_rebuild_jenkins
        return 0
    elif [[ "$jenkins" = "true" && "$install_tropo" = "true" ]]; then
        echo "Rebuilding Jenkins on Troposphere"
        tropo_rebuild_jenkins
        return 0
    fi
    #Troposphere has no dependency on atmosphere, so build it first
    if [ "$install_tropo" = "true" ]; then
        echo "Building Troposphere"
        build_troposphere
    fi

    if [ "$install_atmo" = "true" ]; then
        echo "Building Atmosphere"
        build_atmosphere
    fi

    #ONLY create apache/SSL configurations if atmosphere AND troposphere is being built AND we are
    # building server for a non-test run
    #TODO: A secret file for 'atmo_only' Vs. 'tropo_only' Vs. 'atmo & tropo'
    if [[ "$test_only" = "false" && "$install_tropo" = "true" && "$install_atmo" = "true" ]]
    then
        echo "Building Production Server"
        build_production_server
    fi

    return 0
}


#EXECUTION PATH:
main $@
run_steps
