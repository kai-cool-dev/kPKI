#!/bin/bash
# kPKI Installer
# TODO: Check for Empty Vars

# Variables
BASEFOLDER="$(pwd)"
# Needed programs
MYSQL="$(which mysql)"
MYSQLIMPORT="$(which mysqlimport)"
CFSSL="$BASEFOLDER/../client/cfssl"
CFSSLJSON="$BASEFOLDER/../client/cfssljson"
CAT="$(which cat)"
# Some Go Stuff (Required for the cfssl daemon)
export GOROOT="$BASEFOLDER/../go/"
export PATH=$PATH:$GOROOT/bin
# Server Variables
PKI_URL="http://localhost:8888"
OCSP_URL="http://localhost:8889"
# MySQL Variables
MYSQLHOST="localhost"
MYSQLUSER="root"
MYSQLPASS=""
MYSQLDB="cfssl"
# Config Files Location
CFSSL_MYSQL_EXAMPLE_CONFIG="$BASEFOLDER/../conf/mysql.config.example.json"
CFSSL_MYSQL_CONFIG="$BASEFOLDER/../conf/mysql.config.json"
CFSSL_CA_EXAMPLE_CONFIG="$BASEFOLDER/../conf/ca.config.example.json"
CFSSL_CA_CONFIG="$BASEFOLDER/../conf/ca.config.json"
CFSSL_CLIENT_EXAMPLE_CONFIG="$BASEFOLDER/../conf/client.config.example.json"
CFSSL_CLIENT_CONFIG="$BASEFOLDER/../conf/client.config.json"
HTML_MYSQL_EXAMPLE_CONFIG="$BASEFOLDER/../html/app/config/config.php.sample"
HTML_MYSQL_CONFIG="$BASEFOLDER/../html/app/config/config.php"
HTML_MYSQL_SCHEMA="$BASEFOLDER/../html/schemas/kPKI.schema.sql"

## Main CA
# CA Variables
CA_CN="kPKI root CA"
CA_O="kPKI"
CA_U="PKI Operations"
CA_ST="London"
CA_C="UK"
CA_L="London"
# CA CSR Files Location
CA_FOLDER="$BASEFOLDER/../certs/ca/"
CA_EXAMPLE_CSR="$CA_FOLDER/ca.csr.example.json"
CA_CSR="$CA_FOLDER/ca.csr.json"

## Intermediate CA for signing certificates
# CSR Files Location
ICA_FOLDER="$BASEFOLDER/../certs/intermediate/"
ICA_EXAMPLE_CSR="$ICA_FOLDER/intermediate.csr.example.json"
ICA_CSR="$ICA_FOLDER/intermediate.csr.json"

## OCSP Certificate for signing ocsp responses
# CSR Files Location
OCSP_FOLDER="$BASEFOLDER/../certs/ocsp/"
OCSP_EXAMPLE_CSR="$OCSP_FOLDER/ocsp.csr.example.json"
OCSP_CSR="$OCSP_FOLDER/ocsp.csr.json"

# Functions
function serverconfig()
{
  echo -e "-->\tPlease Type in the public Hostname/IP for the PKI Daemon (please add HTTP(S) Prefix and Port suffix) [Default: http://localhost:8888]:"
  read PKI_URL
  echo -e "\tWe are using '$PKI_URL'"
  echo -e "-->\tPlease Type in the public Hostname/IP for the OCSP Daemon (please add HTTP(S) Prefix and Port suffix) [Default: http://localhost:8889]:"
  read OCSP_URL
  echo -e "\tWe are using '$OCSP_URL'"
}

function addmysql()
{
  echo -e "-->\tPlease Type in the MySQL Host:"
  read MYSQLHOST
  echo -e "\tWe are using '$MYSQLHOST' as the MySQL Hostname"

  echo -e "-->\tPlease Type in the MySQL Username:"
  read MYSQLUSER
  echo -e "\tWe are using '$MYSQLUSER' as the MySQL Username"

  echo -e "-->\tPlease Type in the MySQL Password:"
  read MYSQLPASS
  echo -e "\tWe are using '$MYSQLPASS' as the MySQL Password"

  echo -e "-->\tPlease Type in the MySQL Database:"
  read MYSQLDB
  echo -e "\tWe are using '$MYSQLDB' as the MySQL Database"

  echo -e "-->\tTrying to establish a MySQL Connection"
  if $($MYSQL -B -u $MYSQLUSER -p$MYSQLPASS -h $MYSQLHOST $MYSQLDB -e QUIT)
  then
    echo -e "\tMySQL Connection is working"
  else
    echo -e "\tMySQL Connection is not working. Please check your input!\n"
    exit 0;
  fi

  echo -e "-->\tUpdating Config Files"

  if [ -f $CFSSL_MYSQL_EXAMPLE_CONFIG ]
  then
     $CAT $CFSSL_MYSQL_EXAMPLE_CONFIG | sed "s/MYSQLHOST/$MYSQLHOST/g" | sed "s/MYSQLUSER/$MYSQLUSER/g" | sed "s/MYSQLPASS/$MYSQLPASS/g" | sed "s/MYSQLDB/$MYSQLDB/g" > $CFSSL_MYSQL_CONFIG
  else
    echo -e "\tDaemon MySQL Example Config not found. Aborting."
    exit 0;
  fi

  if [ -f $HTML_MYSQL_EXAMPLE_CONFIG ]
  then
     $CAT $HTML_MYSQL_EXAMPLE_CONFIG | sed "s,PKI_URL,$PKI_URL,g" | sed "s/MYSQLHOST/$MYSQLHOST/g" | sed "s/MYSQLUSER/$MYSQLUSER/g" | sed "s/MYSQLPASS/$MYSQLPASS/g" | sed "s/MYSQLDB/$MYSQLDB/g" > $HTML_MYSQL_CONFIG
  else
    echo -e "\tGUI MySQL Example Config not found. Aborting!"
    exit 0;
  fi

  if [ -f $CFSSL_CA_EXAMPLE_CONFIG ]
  then
    $CAT $CFSSL_CA_EXAMPLE_CONFIG | sed "s,OCSP_URL,$OCSP_URL,g" | sed "s,PKI_URL,$PKI_URL,g" > $CFSSL_CA_CONFIG
  else
    echo -e "\tCA Example Config not found. Aborting!"
    exit 0;
  fi

  if [ -f $CFSSL_CLIENT_EXAMPLE_CONFIG ]
  then
    $CAT $CFSSL_CLIENT_EXAMPLE_CONFIG | sed "s,PKI_URL,$PKI_URL,g" > $CFSSL_CLIENT_CONFIG
  else
    echo -e "\tClient Example Config not found. Aborting!"
    exit 0;
  fi

  echo -e "-->\tImport Schema"
  if [ -f $HTML_MYSQL_SCHEMA ]
  then
    if $($MYSQL -u $MYSQLUSER -p"$MYSQLPASS" -h $MYSQLHOST $MYSQLDB < $HTML_MYSQL_SCHEMA)
    then
      echo -e "\tImport successfull"
    else
      echo -e "\tImport not successfull"
      exit 0;
    fi
  else
    echo -e "\tMySQL Schema not found"
  fi
}

function createCA()
{
  echo -e "-->\tPlease Type in the Name of your CA:"
  read CA_CN
  echo -e "\tWe are using '$CA_CN' as the name of your CA"

  echo -e "-->\tPlease Type in the Organisation:"
  read CA_O
  echo -e "\tWe are using '$CA_O' as Organisation"

  echo -e "-->\tPlease Type in the Organisation Unit:"
  read CA_U
  echo -e "\tWe are using '$CA_U' as Organisation Unit"

  echo -e "-->\tPlease Type in the Locality of your Organisation:"
  read CA_L
  echo -e "\tWe are using '$CA_L' as Locality"

  echo -e "-->\tPlease Type in the State of your Organisation:"
  read CA_ST
  echo -e "\tWe are using '$CA_ST' as State"

  echo -e "-->\tPlease Type in the Country of your Organisation:"
  read CA_C
  echo -e "\tWe are using '$CA_C' as Country"

  if [ -f $CA_EXAMPLE_CSR ]
  then
    $CAT $CA_EXAMPLE_CSR | sed "s/CA_CN/$CA_CN/g" | sed "s/CA_O/$CA_O/g" | sed "s/CA_U/$CA_U/g" | sed "s/CA_L/$CA_L/g" | sed "s/CA_ST/$CA_ST/g" | sed "s/CA_C/$CA_C/g" > $CA_CSR
  else
    echo -e "\tExample CSR File not found. Aborting!"
    exit 0;
  fi

  if [ -f $CA_CSR ]
  then
    if $($CFSSL gencert -initca $CA_CSR | $CFSSLJSON -bare $CA_FOLDER/ca -)
    then
      echo -e "\tCA successfull created."
    else
      echo -e "\tCA could not be created. Aborting!"
      exit 0;
    fi
  else
    echo -e "\tCSR not found. Aborting!"
    exit 0;
  fi
}

function createIntermediate()
{
  echo -e "-->\tPlease Type in the Name of your Intermediate CA:"
  read ICA_CN
  echo -e "\tWe are using '$ICA_CN' as the name of your Intermediate CA"

  if [ -f $ICA_EXAMPLE_CSR ]
  then
    $CAT $ICA_EXAMPLE_CSR | sed "s/ICA_CN/$ICA_CN/g" | sed "s/CA_O/$CA_O/g" | sed "s/CA_U/$CA_U/g" | sed "s/CA_L/$CA_L/g" | sed "s/CA_ST/$CA_ST/g" | sed "s/CA_C/$CA_C/g" > $ICA_CSR
  else
    echo -e "\tExample CSR File not found. Aborting!"
    exit 0;
  fi

  if [ -f $ICA_CSR ]
  then
    if $($CFSSL gencert -ca $CA_FOLDER/ca.pem -ca-key $CA_FOLDER/ca-key.pem -config="$CFSSL_CA_CONFIG" -profile="intermediate" $ICA_CSR | $CFSSLJSON -bare $ICA_FOLDER/intermediate -)
    then
      echo -e "\tIntermediate CA successfull created."
    else
      echo -e "\tIntermediate CA could not be created. Aborting!"
      exit 0;
    fi
  else
    echo -e "\tCSR not found. Aborting!"
    exit 0;
  fi
}

function createOCSP()
{
  echo -e "-->\tPlease Type in the Name of your OCSP Server:"
  read OCSP_CN
  echo -e "\tWe are using '$OCSP_CN' as the name of your OCSP Server"

  if [ -f $OCSP_EXAMPLE_CSR ]
  then
    $CAT $OCSP_EXAMPLE_CSR | sed "s/OCSP_CN/$OCSP_CN/g" | sed "s/CA_O/$CA_O/g" | sed "s/CA_U/$CA_U/g" | sed "s/CA_L/$CA_L/g" | sed "s/CA_ST/$CA_ST/g" | sed "s/CA_C/$CA_C/g" > $OCSP_CSR
  else
    echo -e "\tExample CSR File not found. Aborting!"
    exit 0;
  fi

  if [ -f $OCSP_CSR ]
  then
    if $($CFSSL gencert -ca $ICA_FOLDER/intermediate.pem -ca-key $ICA_FOLDER/intermediate-key.pem -config="$CFSSL_CA_CONFIG" -profile="ocsp" $OCSP_CSR | $CFSSLJSON -bare $OCSP_FOLDER/ocsp -)
    then
      echo -e "\tOCSP Certificate successfull created."
    else
      echo -e "\tOCSP Certificate could not be created. Aborting!"
      exit 0;
    fi
  else
    echo -e "\tCSR not found. Aborting!"
    exit 0;
  fi
}

# Main Routine
echo -e "\tkPKI Installer started"
echo -e "\tServer Configuration"
serverconfig
echo -e "\tMySQL Configuration"
addmysql
echo -e "\tCreate root CA"
createCA
echo -e "\tCreate intermediate CA"
createIntermediate
echo -e "\tCreate OCSP certificate"
createOCSP
# TODO:
# Create OCSP Dump Crontab
# Install Systemd Unit files
# Start Systemd Services
# Install Composer
# Finished
