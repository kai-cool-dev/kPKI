# /bin/bash
# kPKI client
# Copyright 2018 by Kai Pazdzewicz

# Here you can type in the default CSR Data (if this vars are empty you are asked to input)
CERT_O="" # Your Organisation
CERT_U="" # Organisation Unit
CERT_L="" # Locality of your Organisation
CERT_ST="" # State of your Organisation
CERT_C="" # Country of your Organisation

#########################################################
# DO NOT EDIT BEHIND THIS!!!!                           #
#########################################################

# Variables
BASEFOLDER="$(pwd)"
CSR_EXAMPLE="$BASEFOLDER/csr.example.json"
CSR="$BASEFOLDER/csr.json"
CLIENT_CONFIG="$BASEFOLDER/client.config.json"
PROFILE=""
TYPE=""
CERTFOLDER="$BASEFOLDER/live"
CERT_CN=""
CERT_HOSTS=""

# Needed programs
ECHO="$(which echo)"
CFSSL="$BASEFOLDER/cfssl"
CFSSLJSON="$BASEFOLDER/cfssljson"
CAT="$(which cat)"
MKDIR="$(which mkdir)"
SED="$(which sed)"


# Functions
function checkprograms()
{
  if [ -z "$ECHO" ]
  then
    $ECHO -e "\e[31m[-]\techo is missing. Aborting!\e[0m"
    exit 0;
  fi
  if [ -z "$CFSSL" ]
  then
    $ECHO -e "\e[31m[-]\tcfssl is missing. Aborting!\e[0m"
    exit 0;
  fi
  if [ -z "$CFSSLJSON" ]
  then
    $ECHO -e "\e[31m[-]\tcfssljson is missing. Aborting!\e[0m"
    exit 0;
  fi
  if [ -z "$CAT" ]
  then
    $ECHO -e "\e[31m[-]\tcat is missing. Aborting!\e[0m"
    exit 0;
  fi
  if [ -z "$MKDIR" ]
  then
    $ECHO -e "\e[31m[-]\tmkdir is missing. Aborting!\e[0m"
    exit 0;
  fi
  $ECHO -e "\e[32m[+]\tall required programs are there, here you go!\e[0m"
}

function orginfo()
{
  $ECHO -e "\e[33m-->\tPlease type in the Organisation:\e[0m"
  if [ -z "$CERT_O" ]
  then
    read CERT_O
  fi
  if [ -z "$CERT_O" ]
  then
    $ECHO -e "\e[31m[-]\tVariable is empty. Aborting!\e[0m"
    exit 0;
  fi
  $ECHO -e "\e[32m[+]\tWe are using '$CERT_O' as Organisation\e[0m"

  $ECHO -e "\e[33m-->\tPlease type in the Organisation Unit:\e[0m"
  if [ -z "$CERT_U" ]
  then
    read CERT_U
  fi
  if [ -z "$CERT_U" ]
  then
    $ECHO -e "\e[31m[-]\tVariable is empty. Aborting!\e[0m"
    exit 0;
  fi
  $ECHO -e "\e[32m[+]\tWe are using '$CERT_U' as Organisation Unit\e[0m"

  $ECHO -e "\e[33m-->\tPlease type in the Locality of your Organisation:\e[0m"
  if [ -z "$CERT_L" ]
  then
    read CERT_L
  fi
  if [ -z "$CERT_L" ]
  then
    $ECHO -e "\e[31m[-]\tVariable is empty. Aborting!\e[0m"
    exit 0;
  fi
  $ECHO -e "\e[32m[+]\tWe are using '$CERT_L' as Locality\e[0m"

  $ECHO -e "\e[33m-->\tPlease type in the State of your Organisation:\e[0m"
  if [ -z "$CERT_ST" ]
  then
    read CERT_ST
  fi
  if [ -z "$CERT_ST" ]
  then
    $ECHO -e "\e[31m[-]\tVariable is empty. Aborting!\e[0m"
    exit 0;
  fi
  $ECHO -e "\e[32m[+]\tWe are using '$CERT_ST' as State\e[0m"

  $ECHO -e "\e[33m-->\tPlease type in the Country of your Organisation:\e[0m"
  if [ -z "$CERT_C" ]
  then
    read CERT_C
  fi
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
  if [ -z "$CERT_HOSTS" ]
  then
    read CERT_HOSTS
  fi
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
  if [ -z "$CERT_CN" ]
  then
    read CERT_CN
  fi
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
    $CAT $CSR_EXAMPLE | $SED "s,CERT_CN,$CERT_CN,g" | $SED "s/CERT_HOSTS/$CERT_HOSTS/g" | $SED "s,CERT_C,$CERT_C,g" | $SED "s,CERT_L,$CERT_L,g" | $SED "s,CERT_U,$CERT_U,g" | $SED "s,CERT_O,$CERT_O,g" | $SED "s,CERT_ST,$CERT_ST,g" > $CSR
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
$ECHO -e "\tCheck required programs"
checkprograms
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
