#!/bin/bash
# kPKI Installer
# Copyright 2018 Kai Pazdzewicz
# TODO:
# Check for Empty Vars
# Check if needed programs are installed

# Variables
BASEFOLDER="$(pwd | sed 's/install//g')"
# Needed programs
MYSQL="$(which mysql)"
CFSSL="$BASEFOLDER/client/cfssl"
CFSSLJSON="$BASEFOLDER/client/cfssljson"
CAT="$(which cat)"
ECHO="$(which echo)"
WHOAMI="$(which whoami)"
CP="$(which cp)"
SYSTEMCTL="$(which systemctl)"
SYSTEMD_FOLDER="/etc/systemd/system/"
CRONTAB="$(which crontab)"
COMPOSER="$(which composer)"
# Some Go Stuff (Required for the cfssl daemon)
export GOROOT="$BASEFOLDER/go/"
export PATH=$PATH:$GOROOT/bin
# Server Variables
PKI_URL="http://localhost:8888"
OCSP_URL="http://localhost:8889"
# MySQL Variables
MYSQLHOST="localhost"
MYSQLUSER="root"
MYSQLPASS=""
MYSQLDB="cfssl"
MYSQLPORT="3306"
# Config Files Location
CFSSL_MYSQL_EXAMPLE_CONFIG="$BASEFOLDER/conf/mysql.config.example.json"
CFSSL_MYSQL_CONFIG="$BASEFOLDER/conf/mysql.config.json"
CFSSL_CA_EXAMPLE_CONFIG="$BASEFOLDER/conf/ca.config.example.json"
CFSSL_CA_CONFIG="$BASEFOLDER/conf/ca.config.json"
CFSSL_CLIENT_EXAMPLE_CONFIG="$BASEFOLDER/conf/client.config.example.json"
CFSSL_CLIENT_CONFIG="$BASEFOLDER/conf/client.config.json"
HTML_MYSQL_EXAMPLE_CONFIG="$BASEFOLDER/html/app/config/config.php.sample"
HTML_MYSQL_CONFIG="$BASEFOLDER/html/app/config/config.php"
HTML_MYSQL_SCHEMA="$BASEFOLDER/html/schemas/kPKI.schema.sql"

## Main CA
# CA Variables
CA_CN="kPKI root CA"
CA_O="kPKI"
CA_U="PKI Operations"
CA_ST="London"
CA_C="UK"
CA_L="London"
# CA CSR Files Location
CA_FOLDER="$BASEFOLDER/certs/ca/"
CA_EXAMPLE_CSR="$CA_FOLDER/ca.csr.example.json"
CA_CSR="$CA_FOLDER/ca.csr.json"

## Intermediate CA for signing certificates
# CSR Files Location
ICA_FOLDER="$BASEFOLDER/certs/intermediate/"
ICA_EXAMPLE_CSR="$ICA_FOLDER/intermediate.csr.example.json"
ICA_CSR="$ICA_FOLDER/intermediate.csr.json"

## OCSP Certificate for signing ocsp responses
# CSR Files Location
OCSP_FOLDER="$BASEFOLDER/certs/ocsp/"
OCSP_EXAMPLE_CSR="$OCSP_FOLDER/ocsp.csr.example.json"
OCSP_CSR="$OCSP_FOLDER/ocsp.csr.json"

# OCSP Dump
OCSP_DUMP="$BASEFOLDER/ocspdump.txt"

## Systemd Configuration
PKI_EXAMPLE_SERVICE="$BASEFOLDER/install/pki.example.service"
PKI_SERVICE="$BASEFOLDER/install/pki.service"
OCSP_EXAMPLE_SERVICE="$BASEFOLDER/install/ocsp.example.service"
OCSP_SERVICE="$BASEFOLDER/install/ocsp.service"

# Functions
function checktools()
{
  if [ -z $MYSQL ]
  then
    $ECHO -e "[-]\tMYSQL Client not installed"
    exit 0;
  fi
  if [ -z $COMPOSER ]
  then
    $ECHO -e "[-]\tcomposer not installed"
    exit 0;
  fi
  if [ -z $CFSSL ]
  then
    $ECHO -e "[-]\tcfssl in client folder not found"
    exit 0;
  fi
  if [ -z $CFSSLJSON ]
  then
    $ECHO -e "[-]\tcfssl in client folder not found"
    exit 0;
  fi
  if [ -z $ECHO ]
  then
    $ECHO -e "[-]\techo not found"
    exit 0;
  fi
  if [ -z $CAT ]
  then
    $ECHO -e "[-]\tcat not found"
    exit 0;
  fi
  if [ -z $CP ]
  then
    $ECHO -e "[-]\tcp not found"
    exit 0;
  fi
  if [ -z $WHOAMI ]
  then
    $ECHO -e "[-]\twhoami not found"
    exit 0;
  fi
  if [ -z $SYSTEMCTL ]
  then
    $ECHO -e "[-]\tsystemctl not found"
    exit 0;
  fi
  if [ -z $CRONTAB ]
  then
    $ECHO -e "[-]\tcrontab not found"
    exit 0;
  fi
}

function checkroot()
{
  if [[ $($WHOAMI) == "root" ]]
  then
    $ECHO -e "[+]\tOkay, you are running as root"
  else
    $ECHO -e "[-]\tYou are not root, please run this script as root or sudo"
    exit 0;
  fi
}

function serverconfig()
{
  $ECHO -e "\tThis is the configuration for the PKI and OCSP Responder. The Services are always launched on Port 8888 and 8889 but here you can type in the public URL."
  $ECHO -e "\tIt is recommend to use a reverse Proxy."
  $ECHO -e "-->\tPlease Type in the public Hostname/IP for the PKI Daemon (please add HTTP(S) Prefix and Port suffix) [Default: http://localhost:8888]:"
  read PKI_URL
  $ECHO -e "\tWe are using '$PKI_URL'"
  $ECHO -e "-->\tPlease Type in the public Hostname/IP for the OCSP Daemon (please add HTTP(S) Prefix and Port suffix) [Default: http://localhost:8889]:"
  read OCSP_URL
  $ECHO -e "\tWe are using '$OCSP_URL'"
}

function addmysql()
{
  $ECHO -e "-->\tPlease Type in the MySQL Host:"
  read MYSQLHOST
  $ECHO -e "\tWe are using '$MYSQLHOST' as the MySQL Hostname"

  $ECHO -e "-->\tPlease Type in the MySQL Port:"
  read MYSQLPORT
  $ECHO -e "\tWe are using '$MYSQLPORT' as the MySQL Hostname"

  $ECHO -e "-->\tPlease Type in the MySQL Username:"
  read MYSQLUSER
  $ECHO -e "\tWe are using '$MYSQLUSER' as the MySQL Username"

  $ECHO -e "-->\tPlease Type in the MySQL Password:"
  read MYSQLPASS
  $ECHO -e "\tWe are using '$MYSQLPASS' as the MySQL Password"

  $ECHO -e "-->\tPlease Type in the MySQL Database:"
  read MYSQLDB
  $ECHO -e "\tWe are using '$MYSQLDB' as the MySQL Database"

  $ECHO -e "\tTrying to establish a MySQL Connection"
  if $($MYSQL -B -u $MYSQLUSER -p$MYSQLPASS -h $MYSQLHOST $MYSQLDB -P $MYSQLPORT -e QUIT)
  then
    $ECHO -e "\tMySQL Connection is working"
  else
    $ECHO -e "\tMySQL Connection is not working. Please check your input!\n"
    exit 0;
  fi

  $ECHO -e "\tUpdating Config Files"

  if [ -f $CFSSL_MYSQL_EXAMPLE_CONFIG ]
  then
     $CAT $CFSSL_MYSQL_EXAMPLE_CONFIG | sed "s,MYSQLHOST,$MYSQLHOST,g" | sed "s,MYSQLPORT,$MYSQLPORT,g" | sed "s,MYSQLHOST,$MYSQLHOST,g" | sed "s,MYSQLUSER,$MYSQLUSER,g" | sed "s,MYSQLPASS,$MYSQLPASS,g" | sed "s,MYSQLDB,$MYSQLDB,g" > $CFSSL_MYSQL_CONFIG
  else
    $ECHO -e "[-]\tDaemon MySQL Example Config not found. Aborting."
    exit 0;
  fi

  if [ -f $HTML_MYSQL_EXAMPLE_CONFIG ]
  then
     $CAT $HTML_MYSQL_EXAMPLE_CONFIG | sed "s,CA_CN,$CA_CN,g" | sed "s,CA_O,$CA_O,g" | sed "s,CA_U,$CA_U,g" | sed "s,CA_L,$CA_L,g" | sed "s,CA_ST,$CA_ST,g" | sed "s,CA_C,$CA_C,g" | sed "s,PKI_URL,$PKI_URL,g" | sed "s,MYSQLHOST,$MYSQLHOST,g"  | sed "s,MYSQLPORT,$MYSQLPORT,g" | sed "s,MYSQLUSER,$MYSQLUSER,g" | sed "s,MYSQLPASS,$MYSQLPASS,g" | sed "s,MYSQLDB,$MYSQLDB,g" > $HTML_MYSQL_CONFIG
  else
    $ECHO -e "[-]\tGUI MySQL Example Config not found. Aborting!"
    exit 0;
  fi

  if [ -f $CFSSL_CA_EXAMPLE_CONFIG ]
  then
    $CAT $CFSSL_CA_EXAMPLE_CONFIG | sed "s,OCSP_URL,$OCSP_URL,g" | sed "s,PKI_URL,$PKI_URL,g" > $CFSSL_CA_CONFIG
  else
    $ECHO -e "[-]\tCA Example Config not found. Aborting!"
    exit 0;
  fi

  if [ -f $CFSSL_CLIENT_EXAMPLE_CONFIG ]
  then
    $CAT $CFSSL_CLIENT_EXAMPLE_CONFIG | sed "s,PKI_URL,$PKI_URL,g" > $CFSSL_CLIENT_CONFIG
  else
    $ECHO -e "[-]\tClient Example Config not found. Aborting!"
    exit 0;
  fi

  $ECHO -e "-->\tImport Schema"
  if [ -f $HTML_MYSQL_SCHEMA ]
  then
    if $($MYSQL -u $MYSQLUSER -p"$MYSQLPASS" -h $MYSQLHOST $MYSQLDB < $HTML_MYSQL_SCHEMA)
    then
      $ECHO -e "[+]\tImport successfull"
    else
      $ECHO -e "[-]\tImport not successfull"
      exit 0;
    fi
  else
    $ECHO -e "[-]\tMySQL Schema not found"
  fi
}

function cadetails()
{
  $ECHO -e "-->\tPlease Type in the Organisation:"
  read CA_O
  $ECHO -e "\tWe are using '$CA_O' as Organisation"

  $ECHO -e "-->\tPlease Type in the Organisation Unit:"
  read CA_U
  $ECHO -e "\tWe are using '$CA_U' as Organisation Unit"

  $ECHO -e "-->\tPlease Type in the Locality of your Organisation:"
  read CA_L
  $ECHO -e "\tWe are using '$CA_L' as Locality"

  $ECHO -e "-->\tPlease Type in the State of your Organisation:"
  read CA_ST
  $ECHO -e "\tWe are using '$CA_ST' as State"

  $ECHO -e "-->\tPlease Type in the Country of your Organisation:"
  read CA_C
  $ECHO -e "\tWe are using '$CA_C' as Country"
}

function createCA()
{
  $ECHO -e "-->\tPlease Type in the Name of your CA:"
  read CA_CN
  $ECHO -e "\tWe are using '$CA_CN' as the name of your CA"

  if [ -f $CA_EXAMPLE_CSR ]
  then
    $CAT $CA_EXAMPLE_CSR | sed "s,CA_CN,$CA_CN,g" | sed "s,CA_O,$CA_O,g" | sed "s,CA_U,$CA_U,g" | sed "s,CA_L,$CA_L,g" | sed "s,CA_ST,$CA_ST,g" | sed "s,CA_C,$CA_C,g" > $CA_CSR
  else
    $ECHO -e "[-]\tExample CSR File not found. Aborting!"
    exit 0;
  fi

  if [ -f $CA_CSR ]
  then
    if $($CFSSL gencert -initca $CA_CSR | $CFSSLJSON -bare $CA_FOLDER/ca -)
    then
      $ECHO -e "[+]\tCA successfull created."
    else
      $ECHO -e "[-]\tCA could not be created. Aborting!"
      exit 0;
    fi
  else
    $ECHO -e "[-]\tCSR not found. Aborting!"
    exit 0;
  fi
}

function createIntermediate()
{
  $ECHO -e "-->\tPlease Type in the Name of your Intermediate CA:"
  read ICA_CN
  $ECHO -e "\tWe are using '$ICA_CN' as the name of your Intermediate CA"

  if [ -f $ICA_EXAMPLE_CSR ]
  then
    $CAT $ICA_EXAMPLE_CSR | sed "s,ICA_CN,$ICA_CN,g" | sed "s,CA_O,$CA_O,g" | sed "s,CA_U,$CA_U,g" | sed "s,CA_L,$CA_L,g" | sed "s,CA_ST,$CA_ST,g" | sed "s,CA_C,$CA_C,g" > $ICA_CSR
  else
    $ECHO -e "[-]\tExample CSR File not found. Aborting!"
    exit 0;
  fi

  if [ -f $ICA_CSR ]
  then
    if $($CFSSL gencert -ca $CA_FOLDER/ca.pem -ca-key $CA_FOLDER/ca-key.pem -config="$CFSSL_CA_CONFIG" -profile="intermediate" $ICA_CSR | $CFSSLJSON -bare $ICA_FOLDER/intermediate -)
    then
      $ECHO -e "[+]\tIntermediate CA successfull created."
    else
      $ECHO -e "[-]\tIntermediate CA could not be created. Aborting!"
      exit 0;
    fi
  else
    $ECHO -e "[-]\tCSR not found. Aborting!"
    exit 0;
  fi
}

function createOCSP()
{
  $ECHO -e "-->\tPlease Type in the Name of your OCSP Server:"
  read OCSP_CN
  $ECHO -e "\tWe are using '$OCSP_CN' as the name of your OCSP Server"

  if [ -f $OCSP_EXAMPLE_CSR ]
  then
    $CAT $OCSP_EXAMPLE_CSR | sed "s,OCSP_CN,$OCSP_CN,g" | sed "s,CA_O,$CA_O,g" | sed "s,CA_U,$CA_U,g" | sed "s,CA_L,$CA_L,g" | sed "s,CA_ST,$CA_ST,g" | sed "s,CA_C,$CA_C,g" > $OCSP_CSR
  else
    $ECHO -e "[-]\tExample CSR File not found. Aborting!"
    exit 0;
  fi

  if [ -f $OCSP_CSR ]
  then
    if $($CFSSL gencert -ca $ICA_FOLDER/intermediate.pem -ca-key $ICA_FOLDER/intermediate-key.pem -config="$CFSSL_CA_CONFIG" -profile="ocsp" $OCSP_CSR | $CFSSLJSON -bare $OCSP_FOLDER/ocsp -)
    then
      $ECHO -e "[+]\tOCSP Certificate successfull created."
    else
      $ECHO -e "[-]\tOCSP Certificate could not be created. Aborting!"
      exit 0;
    fi
  else
    $ECHO -e "[-]\tCSR not found. Aborting!"
    exit 0;
  fi
}

function installsystemd()
{
  $ECHO -e "\tInstalling PKI Service"
  if [ -f $PKI_EXAMPLE_SERVICE ]
  then
    $CAT $PKI_EXAMPLE_SERVICE | sed "s,BASEFOLDER,$BASEFOLDER,g" | sed "s,CFSSL_MYSQL_CONFIG,$CFSSL_MYSQL_CONFIG,g" | sed "s,CFSSL_CA_CONFIG,$CFSSL_CA_CONFIG,g" | sed "s,CFSSL,$CFSSL,g" | sed "s,ICA_FOLDER,$ICA_FOLDER,g" | sed "s,OCSP_FOLDER,$OCSP_FOLDER,g" | sed "s,OCSP_FOLDER,$OCSP_FOLDER,g" > $PKI_SERVICE
  else
    $ECHO -e "[-]\tExample PKI Systemd Service not found"
    exit 0;
  fi
  if [ -f $PKI_SERVICE ]
  then
    $CP $PKI_SERVICE $SYSTEMD_FOLDER/pki.service
    $SYSTEMCTL enable $SYSTEMD_FOLDER/pki.service
  else
    $ECHO -e "[-]\tPKI Systemd Service not found"
    exit 0;
  fi
  $ECHO -e "\tStart PKI Service"
  if $($SYSTEMCTL start pki.service)
  then
    $ECHO -e "[+]\tPKI Service started."
  else
    $ECHO -e "[-]\tPKI Service could not started. Aborting."
    exit 0;
  fi
  $ECHO -e "\tInstall OCSP Service"
  if [ -f $OCSP_EXAMPLE_SERVICE ]
  then
    $CAT $OCSP_EXAMPLE_SERVICE | sed "s,BASEFOLDER,$BASEFOLDER,g" | sed "s,CFSSL,$CFSSL,g" | sed "s,OCSP_DUMP,$OCSP_DUMP,g" > $OCSP_SERVICE
  else
    $ECHO -e "[-]\tExample OCSP Systemd Service not found"
    exit 0;
  fi
  if [ -f $OCSP_SERVICE ]
  then
    $CP $OCSP_SERVICE $SYSTEMD_FOLDER/ocsp.service
    $SYSTEMCTL enable $SYSTEMD_FOLDER/ocsp.service
  else
    $ECHO -e "[-]\OCSP Systemd Service not found"
    exit 0;
  fi
  if $($SYSTEMCTL start ocsp.service)
  then
    $ECHO -e "[+]\tOCSP Service started."
  else
    $ECHO -e "[-]\tOCSP Service could not started. Aborting."
    exit 0;
  fi
}

function dumpocsp()
{
  $ECHO -e "\tCreate OCSP Dump"
  if $($CFSSL ocspdump -db-config $CFSSL_MYSQL_CONFIG > $OCSP_DUMP)
  then
    $ECHO -e "[+]\tOCSP dump created"
  else
    $ECHO -e "[-]\tOCSP dump not created. Aborting."
    exit 0;
  fi
  $ECHO -e "\tCreate Cronjob"
  if $(($CRONTAB -l ; $ECHO "0 0 */5 * * $CFSSL ocspdump -db-config $CFSSL_MYSQL_CONFIG > $OCSP_DUMP") | $CRONTAB -)
  then
    $ECHO -e "[+]\tCronjob installed"
  else
    $ECHO -e "[-]\tCronjob not installed. Aborting."
    exit 0;
  fi
}

function installcomposer()
{
  if $($COMPOSER --working-dir=$BASEFOLDER/html/ -n install)
  then
    $ECHO -e "[+]\tDependencies installed"
  else
    $ECHO -e "[-]\tDependencies not installed. Aborting."
    exit 0;
  fi
}

# Main Routine
$ECHO -e "\tkPKI Installer started"
$ECHO -e "\tCheck tools / needed programs"
checktools
$ECHO -e "\tCheck root privileges."
checkroot
$ECHO -e "\tServer Configuration"
serverconfig
$ECHO -e "\tOrganisation Details"
cadetails
$ECHO -e "\tMySQL Configuration"
addmysql
$ECHO -e "\tCreate root CA"
createCA
$ECHO -e "\tCreate intermediate CA"
createIntermediate
$ECHO -e "\tCreate OCSP certificate"
createOCSP
$ECHO -e "\tDump OCSP responses and create OCSP dump crontab"
dumpocsp
$ECHO -e "\tCreate Systemd Unit files and start services"
installsystemd
$ECHO -e "\tInstall dependencies for web GUI"
installcomposer
