# /bin/bash
# kPKI client
# Copyright 2018 by Kai Pazdzewicz

# TODO:
# check programs
# add client certificate creation
# Check goroot/gopath


# Variables
BASEFOLDER="$(pwd)"
CSR_EXAMPLE="$BASEFOLDER/csr.example.json"
CSR="$BASEFOLDER/csr.json"
CLIENT_CONFIG="$BASEFOLDER/client.config.json"
PROFILE="server"
TYPE="1"
CERTFOLDER="$BASEFOLDER/live"

# CSR Vars
CERT_C="UK"
CERT_L="London"
CERT_U="DATA SERVICES"
CERT_O="420 SERVICES"
CERT_ST="London"
CERT_HOSTS=""
CERT_CN="test1"

# Needed programs
ECHO="$(which echo)"
CFSSL="$BASEFOLDER/cfssl"
CFSSLJSON="$BASEFOLDER/cfssljson"
CAT="$(which cat)"
MKDIR="$(which mkdir)"


# Functions
function orginfo()
{
  $ECHO -e "\e[33m-->\tPlease type in the Organisation:\e[0m"
  read CERT_O
  if [ -z "$CERT_O" ]
  then
    $ECHO -e "\e[31m[-]\tVariable is empty. Aborting!\e[0m"
    exit 0;
  fi
  $ECHO -e "\e[32m[+]\tWe are using '$CERT_O' as Organisation\e[0m"

  $ECHO -e "\e[33m-->\tPlease type in the Organisation Unit:\e[0m"
  read CERT_U
  if [ -z "$CERT_U" ]
  then
    $ECHO -e "\e[31m[-]\tVariable is empty. Aborting!\e[0m"
    exit 0;
  fi
  $ECHO -e "\e[32m[+]\tWe are using '$CERT_U' as Organisation Unit\e[0m"

  $ECHO -e "\e[33m-->\tPlease type in the Locality of your Organisation:\e[0m"
  read CERT_L
  if [ -z "$CERT_L" ]
  then
    $ECHO -e "\e[31m[-]\tVariable is empty. Aborting!\e[0m"
    exit 0;
  fi
  $ECHO -e "\e[32m[+]\tWe are using '$CERT_L' as Locality\e[0m"

  $ECHO -e "\e[33m-->\tPlease type in the State of your Organisation:\e[0m"
  read CERT_ST
  if [ -z "$CERT_ST" ]
  then
    $ECHO -e "\e[31m[-]\tVariable is empty. Aborting!\e[0m"
    exit 0;
  fi
  $ECHO -e "\e[32m[+]\tWe are using '$CERT_ST' as State\e[0m"

  $ECHO -e "\e[33m-->\tPlease type in the Country of your Organisation:\e[0m"
  read CERT_C
  if [ -z "$CERT_C" ]
  then
    $ECHO -e "\e[31m[-]\tVariable is empty. Aborting!\e[0m"
    exit 0;
  fi
  $ECHO -e "\e[32m[+]\tWe are using '$CERT_C' as Country\e[0m"
}

function addhosts()
{
  $ECHO -e "\e[33m-->\tPlease type in your command seperated hosts (e.g. example.com,www.example.com,sub.example.com):\e[0m"
  read CERT_HOSTS
  if [ -z "$CERT_HOSTS" ]
  then
    $ECHO -e "\e[31m[-]\tVariable is empty. Aborting!\e[0m"
    exit 0;
  fi
  $ECHO -e "\e[32m[+]\tWe are using '$CERT_HOSTS'\e[0m"
  HOSTLIST="$(printf '"%s"\n' "${CERT_HOSTS//,/\",\"}")"
  CERT_CN="$($ECHO $CERT_HOSTS | cut -d',' -f1)"
  CERT_HOSTS="\"hosts\":[$HOSTLIST],"
}

function userinfo()
{
  $ECHO -e "\e[33m-->\tPlease type in the user information:\e[0m"
  read CERT_CN
  if [ -z "$CERT_CN" ]
  then
    $ECHO -e "\e[31m[-]\tVariable is empty. Aborting!\e[0m"
    exit 0;
  fi
  $ECHO -e "\e[32m[+]\tWe are using '$CERT_CN'\e[0m"
}

function generatecsr()
{
  if [ -f $CSR_EXAMPLE ]
  then
    $CAT $CSR_EXAMPLE | sed "s,CERT_CN,$CERT_CN,g" | sed "s/CERT_HOSTS/$CERT_HOSTS/g" | sed "s,CERT_C,$CERT_C,g" | sed "s,CERT_L,$CERT_L,g" | sed "s,CERT_U,$CERT_U,g" | sed "s,CERT_O,$CERT_O,g" | sed "s,CERT_ST,$CERT_ST,g" > $CSR
  else
    $ECHO -e "\e[31m[-]\tCSR Example not found. Aborting!\e[0m"
    exit 0;
  fi
}

function gettype()
{
  $ECHO -e "\e[33m-->\tPlease select the type of certificate\n1 - server certificate with SAN hosts\n2 - client certificate\e[0m"
  read TYPE
  if [ -z "$TYPE" ]
  then
    $ECHO -e "\e[31m[-]\tVariable is empty. Aborting!\e[0m"
    exit 0;
  fi
  case $TYPE in
    1)
      PROFILE="server"
    ;;
    2)
      PROFILE="client"
    ;;
    *)
      $ECHO -e "\e[31m[-]\tType not supported. Aborting!\e[0m"
      exit 0;
    ;;
  esac
  $ECHO -e "\e[32m[+]\tWe are using type '$PROFILE'\e[0m"
}

function generatecert()
{
  if [ ! -d "$CERTFOLDER" ]
  then
    $MKDIR $CERTFOLDER
  fi
  if [ ! -d "$CERTFOLDER/$CERT_CN" ]
  then
    $MKDIR $CERTFOLDER/$CERT_CN
  fi
  if [ -f $CLIENT_CONFIG ]
  then
    if [ -f $CSR ]
    then
      $CFSSL gencert -profile $PROFILE -config $CLIENT_CONFIG $CSR | $CFSSLJSON -bare $CERTFOLDER/$CERT_CN/$CERT_CN
    else
      $ECHO -e "\e[31m[-]\tCSR not found. Aborting!\e[0m"
      exit 0;
    fi
  else
    $ECHO -e "\e[31m[-]\tClient Config not found. Aborting!\e[0m"
    exit 0;
  fi
}

# Main Routine
$ECHO -e "\tWelcome to the kPKI client"
$ECHO -e "\tOrganisation Information"
orginfo
$ECHO -e "\tCertificate Type"
gettype
if [[ $PROFILE == "server" ]]
then
  $ECHO -e "\tHosts Information"
  addhosts
else
  $ECHO -e "\tUser Information"
  userinfo
fi
$ECHO -e "\tGenerate CSR"
generatecsr
$ECHO -e "\tGenerate Certificate"
generatecert
