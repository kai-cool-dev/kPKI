#!/bin/bash
# kPKI Installer
# Copyright 2018 Kai Pazdzewicz

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
CFSSL_CLIENT_CONFIG="$BASEFOLDER/client/client.config.json"
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
    $ECHO -e "\e[31m[-]\tMYSQL Client not installed. Aborting\e[0m\e[0m"
    exit 0;
  fi
  if [ -z $COMPOSER ]
  then
    $ECHO -e "\e[31m[-]\tcomposer not installed"
    exit 0;
  fi
  if [ -z $CFSSL ]
  then
    $ECHO -e "\e[31m[-]\tcfssl in client folder not found"
    exit 0;
  fi
  if [ -z $CFSSLJSON ]
  then
    $ECHO -e "\e[31m[-]\tcfssl in client folder not found"
    exit 0;
  fi
  if [ -z $ECHO ]
  then
    $ECHO -e "\e[31m[-]\techo not found"
    exit 0;
  fi
  if [ -z $CAT ]
  then
    $ECHO -e "\e[31m[-]\tcat not found"
    exit 0;
  fi
  if [ -z $CP ]
  then
    $ECHO -e "\e[31m[-]\tcp not found"
    exit 0;
  fi
  if [ -z $WHOAMI ]
  then
    $ECHO -e "\e[31m[-]\twhoami not found"
    exit 0;
  fi
  if [ -z $SYSTEMCTL ]
  then
    $ECHO -e "\e[31m[-]\tsystemctl not found"
    exit 0;
  fi
  if [ -z $CRONTAB ]
  then
    $ECHO -e "\e[31m[-]\tcrontab not found"
    exit 0;
  fi
}

function checkroot()
{
  if [[ $($WHOAMI) == "root" ]]
  then
    $ECHO -e "\e[32m[+]\tOkay, you are running as root.\e[0m"
  else
    $ECHO -e "\e[31m[-]\tYou are not root, please run this script as root or sudo. Aborting!\e[0m"
    exit 0;
  fi
}

function serverconfig()
{
  $ECHO -e "\tThis is the configuration for the PKI and OCSP Responder. The Services are always launched on Port 8888 and 8889 but here you can type in the public URL."
  $ECHO -e "\tIt is recommend to use a reverse Proxy."
  $ECHO -e "\e[33m-->\tPlease type in the public Hostname/IP for the PKI Daemon (please add HTTP(S) Prefix and Port suffix) [Default: http://localhost:8888]:"
  read PKI_URL
  if [ -z $PKI_URL ]
  then
    $ECHO -e "\e[31m[-]\tVariable is empty."
    exit 0;
  fi
  $ECHO -e "\e[32m[+]\tWe are using '$PKI_URL'\e[0m"
  $ECHO -e "\e[33m-->\tPlease type in the public Hostname/IP for the OCSP Daemon (please add HTTP(S) Prefix and Port suffix) [Default: http://localhost:8889]:"
  read OCSP_URL
  if [ -z $OCSP_URL ]
  then
    $ECHO -e "\e[31m[-]\tVariable is empty."
    exit 0;
  fi
  $ECHO -e "\e[32m[+]\tWe are using '$OCSP_URL'\e[0m"
}

function addmysql()
{
  $ECHO -e "\e[33m-->\tPlease type in the MySQL Host:\e[0m"
  read MYSQLHOST
  if [ -z $MYSQLHOST ]
  then
    $ECHO -e "\e[31m[-]\tVariable is empty."
    exit 0;
  fi
  $ECHO -e "\e[32m[+]\tWe are using '$MYSQLHOST' as the MySQL Hostname\e[0m"

  $ECHO -e "\e[33m-->\tPlease type in the MySQL Port:\e[0m"
  read MYSQLPORT
  if [ -z $MYSQLPORT ]
  then
    $ECHO -e "\e[31m[-]\tVariable is empty."
    exit 0;
  fi
  $ECHO -e "\e[32m[+]\tWe are using '$MYSQLPORT' as the MySQL Hostname\e[0m"

  $ECHO -e "\e[33m-->\tPlease type in the MySQL Username:\e[0m"
  read MYSQLUSER
  if [ -z $MYSQLUSER ]
  then
    $ECHO -e "\e[31m[-]\tVariable is empty."
    exit 0;
  fi
  $ECHO -e "\e[32m[+]\tWe are using '$MYSQLUSER' as the MySQL Username\e[0m"

  $ECHO -e "\e[33m-->\tPlease type in the MySQL Password:\e[0m"
  read MYSQLPASS
  if [ -z $MYSQLPASS ]
  then
    $ECHO -e "\e[31m[-]\tVariable is empty."
    exit 0;
  fi
  $ECHO -e "\e[32m[+]\tWe are using '$MYSQLPASS' as the MySQL Password\e[0m"

  $ECHO -e "\e[33m-->\tPlease type in the MySQL Database:\e[0m"
  read MYSQLDB
  if [ -z $MYSQLDB ]
  then
    $ECHO -e "\e[31m[-]\tVariable is empty. Aborting!\e[0m\e[0m"
    exit 0;
  fi
  $ECHO -e "\e[32m[+]\tWe are using '$MYSQLDB' as the MySQL Database\e[0m"

  $ECHO -e "\tTrying to establish a MySQL Connection"
  if $($MYSQL -B -u $MYSQLUSER -p$MYSQLPASS -h $MYSQLHOST $MYSQLDB -P $MYSQLPORT -e QUIT)
  then
    $ECHO -e "\e[32m[+]\tMySQL Connection is working\e[0m"
  else
    $ECHO -e "\e[31m[-]\tMySQL Connection is not working. Aborting!\e[0m"
    exit 0;
  fi

  $ECHO -e "\tUpdating Config Files"

  if [ -f $CFSSL_MYSQL_EXAMPLE_CONFIG ]
  then
     $CAT $CFSSL_MYSQL_EXAMPLE_CONFIG | sed "s,MYSQLHOST,$MYSQLHOST,g" | sed "s,MYSQLPORT,$MYSQLPORT,g" | sed "s,MYSQLHOST,$MYSQLHOST,g" | sed "s,MYSQLUSER,$MYSQLUSER,g" | sed "s,MYSQLPASS,$MYSQLPASS,g" | sed "s,MYSQLDB,$MYSQLDB,g" > $CFSSL_MYSQL_CONFIG
  else
    $ECHO -e "\e[31m[-]\tDaemon MySQL Example Config not found. Aborting!\e[0m"
    exit 0;
  fi

  if [ -f $HTML_MYSQL_EXAMPLE_CONFIG ]
  then
     $CAT $HTML_MYSQL_EXAMPLE_CONFIG | sed "s,CA_CN,$CA_CN,g" | sed "s,CA_O,$CA_O,g" | sed "s,CA_U,$CA_U,g" | sed "s,CA_L,$CA_L,g" | sed "s,CA_ST,$CA_ST,g" | sed "s,CA_C,$CA_C,g" | sed "s,PKI_URL,$PKI_URL,g" | sed "s,MYSQLHOST,$MYSQLHOST,g"  | sed "s,MYSQLPORT,$MYSQLPORT,g" | sed "s,MYSQLUSER,$MYSQLUSER,g" | sed "s,MYSQLPASS,$MYSQLPASS,g" | sed "s,MYSQLDB,$MYSQLDB,g" > $HTML_MYSQL_CONFIG
  else
    $ECHO -e "\e[31m[-]\tGUI MySQL Example Config not found. Aborting!\e[0m"
    exit 0;
  fi

  if [ -f $CFSSL_CA_EXAMPLE_CONFIG ]
  then
    $CAT $CFSSL_CA_EXAMPLE_CONFIG | sed "s,OCSP_URL,$OCSP_URL,g" | sed "s,PKI_URL,$PKI_URL,g" > $CFSSL_CA_CONFIG
  else
    $ECHO -e "\e[31m[-]\tCA Example Config not found. Aborting!\e[0m"
    exit 0;
  fi

  if [ -f $CFSSL_CLIENT_EXAMPLE_CONFIG ]
  then
    $CAT $CFSSL_CLIENT_EXAMPLE_CONFIG | sed "s,PKI_URL,$PKI_URL,g" > $CFSSL_CLIENT_CONFIG
  else
    $ECHO -e "\e[31m[-]\tClient Example Config not found. Aborting!\e[0m"
    exit 0;
  fi

  $ECHO -e "\e[33m-->\tImport Schema"
  if [ -f $HTML_MYSQL_SCHEMA ]
  then
    if $($MYSQL -u $MYSQLUSER -p"$MYSQLPASS" -h $MYSQLHOST $MYSQLDB < $HTML_MYSQL_SCHEMA)
    then
      $ECHO -e "\e[32m[+]\tImport successfull\e[0m"
    else
      $ECHO -e "\e[31m[-]\tImport not successfull. Aborting!\e[0m"
      exit 0;
    fi
  else
    $ECHO -e "\e[31m[-]\tMySQL Schema not found. Aborting!\e[0m"
    exit 0;
  fi
}

function cadetails()
{
  $ECHO -e "\e[33m-->\tPlease type in the Organisation:\e[0m"
  read CA_O
  if [ -z "$CA_O" ]
  then
    $ECHO -e "\e[31m[-]\tVariable is empty. Aborting!\e[0m"
    exit 0;
  fi
  $ECHO -e "\e[32m[+]\tWe are using '$CA_O' as Organisation\e[0m"

  $ECHO -e "\e[33m-->\tPlease type in the Organisation Unit:\e[0m"
  read CA_U
  if [ -z "$CA_U" ]
  then
    $ECHO -e "\e[31m[-]\tVariable is empty. Aborting!\e[0m"
    exit 0;
  fi
  $ECHO -e "\e[32m[+]\tWe are using '$CA_U' as Organisation Unit\e[0m"

  $ECHO -e "\e[33m-->\tPlease type in the Locality of your Organisation:\e[0m"
  read CA_L
  if [ -z "$CA_L" ]
  then
    $ECHO -e "\e[31m[-]\tVariable is empty. Aborting!\e[0m"
    exit 0;
  fi
  $ECHO -e "\e[32m[+]\tWe are using '$CA_L' as Locality\e[0m"

  $ECHO -e "\e[33m-->\tPlease type in the State of your Organisation:\e[0m"
  read CA_ST
  if [ -z "$CA_ST" ]
  then
    $ECHO -e "\e[31m[-]\tVariable is empty. Aborting!\e[0m"
    exit 0;
  fi
  $ECHO -e "\e[32m[+]\tWe are using '$CA_ST' as State\e[0m"

  $ECHO -e "\e[33m-->\tPlease type in the Country of your Organisation:\e[0m"
  read CA_C
  if [ -z "$CA_C" ]
  then
    $ECHO -e "\e[31m[-]\tVariable is empty. Aborting!\e[0m"
    exit 0;
  fi
  $ECHO -e "\e[32m[+]\tWe are using '$CA_C' as Country\e[0m"
}

function createCA()
{
  $ECHO -e "\e[33m-->\tPlease type in the Name of your CA:\e[0m\e[0m"
  read CA_CN
  if [ -z "$CA_CN" ]
  then
    $ECHO -e "\e[31m[-]\tVariable is empty. Aborting!\e[0m"
    exit 0;
  fi
  $ECHO -e "\e[32m[+]\tWe are using '$CA_CN' as the name of your CA\e[0m"

  if [ -f $CA_EXAMPLE_CSR ]
  then
    $CAT $CA_EXAMPLE_CSR | sed "s,CA_CN,$CA_CN,g" | sed "s,CA_O,$CA_O,g" | sed "s,CA_U,$CA_U,g" | sed "s,CA_L,$CA_L,g" | sed "s,CA_ST,$CA_ST,g" | sed "s,CA_C,$CA_C,g" > $CA_CSR
  else
    $ECHO -e "\e[31m[-]\tExample CSR File not found. Aborting!\e[0m"
    exit 0;
  fi

  if [ -f $CA_CSR ]
  then
    if $($CFSSL gencert -initca $CA_CSR | $CFSSLJSON -bare $CA_FOLDER/ca -)
    then
      $ECHO -e "\e[32m[+]\tCA successfull created\e[0m"
    else
      $ECHO -e "\e[31m[-]\tCA could not be created. Aborting!\e[0m"
      exit 0;
    fi
  else
    $ECHO -e "\e[31m[-]\tCSR not found. Aborting!\e[0m"
    exit 0;
  fi
}

function createIntermediate()
{
  $ECHO -e "\e[33m-->\tPlease type in the Name of your Intermediate CA:\e[0m"
  read ICA_CN
  if [ -z "$ICA_CN" ]
  then
    $ECHO -e "\e[31m[-]\tVariable is empty. Aborting!\e[0m"
    exit 0;
  fi
  $ECHO -e "\e[32m[+]\tWe are using '$ICA_CN' as the name of your Intermediate CA\e[0m"

  if [ -f $ICA_EXAMPLE_CSR ]
  then
    $CAT $ICA_EXAMPLE_CSR | sed "s,ICA_CN,$ICA_CN,g" | sed "s,CA_O,$CA_O,g" | sed "s,CA_U,$CA_U,g" | sed "s,CA_L,$CA_L,g" | sed "s,CA_ST,$CA_ST,g" | sed "s,CA_C,$CA_C,g" > $ICA_CSR
  else
    $ECHO -e "\e[31m[-]\tExample CSR File not found. Aborting!\e[0m"
    exit 0;
  fi

  if [ -f $ICA_CSR ]
  then
    if $($CFSSL gencert -ca $CA_FOLDER/ca.pem -ca-key $CA_FOLDER/ca-key.pem -config="$CFSSL_CA_CONFIG" -profile="intermediate" $ICA_CSR | $CFSSLJSON -bare $ICA_FOLDER/intermediate -)
    then
      $ECHO -e "\e[32m[+]\tIntermediate CA successfull created\e[0m"
    else
      $ECHO -e "\e[31m[-]\tIntermediate CA could not be created. Aborting!\e[0m"
      exit 0;
    fi
  else
    $ECHO -e "\e[31m[-]\tCSR not found. Aborting!\e[0m"
    exit 0;
  fi
}

function createOCSP()
{
  $ECHO -e "\e[33m-->\tPlease type in the Name of your OCSP Server:\e[0m"
  read OCSP_CN
  if [ -z "$OCSP_CN" ]
  then
    $ECHO -e "\e[31m[-]\tVariable is empty. Aborting!\e[0m"
    exit 0;
  fi
  $ECHO -e "\e[32m[+]\tWe are using '$OCSP_CN' as the name of your OCSP Server\e[0m"

  if [ -f $OCSP_EXAMPLE_CSR ]
  then
    $CAT $OCSP_EXAMPLE_CSR | sed "s,OCSP_CN,$OCSP_CN,g" | sed "s,CA_O,$CA_O,g" | sed "s,CA_U,$CA_U,g" | sed "s,CA_L,$CA_L,g" | sed "s,CA_ST,$CA_ST,g" | sed "s,CA_C,$CA_C,g" > $OCSP_CSR
  else
    $ECHO -e "\e[31m[-]\tExample CSR File not found. Aborting!\e[0m"
    exit 0;
  fi

  if [ -f $OCSP_CSR ]
  then
    if $($CFSSL gencert -ca $ICA_FOLDER/intermediate.pem -ca-key $ICA_FOLDER/intermediate-key.pem -config="$CFSSL_CA_CONFIG" -profile="ocsp" $OCSP_CSR | $CFSSLJSON -bare $OCSP_FOLDER/ocsp -)
    then
      $ECHO -e "\e[32m[+]\tOCSP Certificate successfull created\e[0m"
    else
      $ECHO -e "\e[31m[-]\tOCSP Certificate could not be created. Aborting!\e[0m"
      exit 0;
    fi
  else
    $ECHO -e "\e[31m[-]\tCSR not found. Aborting!\e[0m"
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
    $ECHO -e "\e[31m[-]\tExample PKI Systemd Service not found. Aborting!\e[0m"
    exit 0;
  fi
  if [ -f $PKI_SERVICE ]
  then
    $CP $PKI_SERVICE $SYSTEMD_FOLDER/pki.service
    $SYSTEMCTL enable $SYSTEMD_FOLDER/pki.service
  else
    $ECHO -e "\e[31m[-]\tPKI Systemd Service not found"
    exit 0;
  fi
  $ECHO -e "\tStart PKI Service"
  if $($SYSTEMCTL start pki.service)
  then
    $ECHO -e "\e[32m[+]\tPKI Service started\e[0m"
  else
    $ECHO -e "\e[31m[-]\tPKI Service could not started. Aborting!\e[0m"
    exit 0;
  fi
  $ECHO -e "\tInstall OCSP Service"
  if [ -f $OCSP_EXAMPLE_SERVICE ]
  then
    $CAT $OCSP_EXAMPLE_SERVICE | sed "s,BASEFOLDER,$BASEFOLDER,g" | sed "s,CFSSL,$CFSSL,g" | sed "s,OCSP_DUMP,$OCSP_DUMP,g" > $OCSP_SERVICE
  else
    $ECHO -e "\e[31m[-]\tExample OCSP Systemd Service not found. Aborting!\e[0m"
    exit 0;
  fi
  if [ -f $OCSP_SERVICE ]
  then
    $CP $OCSP_SERVICE $SYSTEMD_FOLDER/ocsp.service
    $SYSTEMCTL enable $SYSTEMD_FOLDER/ocsp.service
  else
    $ECHO -e "\e[31m[-]\OCSP Systemd Service not found. Aborting!\e[0m"
    exit 0;
  fi
  if $($SYSTEMCTL start ocsp.service)
  then
    $ECHO -e "\e[32m[+]\tOCSP Service started\e[0m"
  else
    $ECHO -e "\e[31m[-]\tOCSP Service could not started. Aborting!\e[0m"
    exit 0;
  fi
}

function dumpocsp()
{
  $ECHO -e "\tCreate OCSP Dump"
  if $($CFSSL ocspdump -db-config $CFSSL_MYSQL_CONFIG > $OCSP_DUMP)
  then
    $ECHO -e "\e[32m[+]\tOCSP dump created\e[0m"
  else
    $ECHO -e "\e[31m[-]\tOCSP dump not created. Aborting!\e[0m"
    exit 0;
  fi
  $ECHO -e "\tCreate Cronjob"
  if $(($CRONTAB -l ; $ECHO "0 0 */5 * * $CFSSL ocspdump -db-config $CFSSL_MYSQL_CONFIG > $OCSP_DUMP") | $CRONTAB -)
  then
    $ECHO -e "\e[32m[+]\tCronjob installed\e[0m"
  else
    $ECHO -e "\e[31m[-]\tCronjob not installed. Aborting!\e[0m"
    exit 0;
  fi
}

function installcomposer()
{
  if $($COMPOSER --working-dir=$BASEFOLDER/html/ -n install)
  then
    $ECHO -e "\e[32m[+]\tDependencies installed\e[0m"
  else
    $ECHO -e "\e[31m[-]\tDependencies not installed. Aborting!\e[0m"
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
