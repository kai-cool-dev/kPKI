#!/bin/bash
# Generiert ein neues SSL File basierend auf einem CSR
SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`
POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
    -c|--csr)
      CSR="$2"
      shift # past argument
      shift # past value
    ;;
    -n|--name)
      NAME="$2"
      shift # past argument
      shift # past value
    ;;
    -d|--dir)
      DIRECTORY="$2"
      shift # past argument
      shift # past value
    ;;
    *)    # unknown option
      POSITIONAL+=("$1") # save it in an array for later
      shift # past argument
    ;;
  esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [ "$CSR" == "" ]
then
  echo "Parameter -c/--csr <path/to/csr.json> missing!"
  exit 1
fi
if ! [ -f "$CSR" ]
then
  echo "Path to CSR.json not valid!"
  exit 1
fi
if [ "$NAME" == "" ]
then
  echo "Parameter -n/--name <certname> missing!"
  exit 1
fi
if [ "$DIRECTORY" == "" ]
then
  echo "Parameter -d/--dir <path/to/destination/> missing!"
  exit 1
fi

$SCRIPTPATH/cfssl gencert -config="$SCRIPTPATH/config_client.json" -profile="client" "$CSR" | $SCRIPTPATH/cfssljson -bare "$DIRECTORY/$NAME"
