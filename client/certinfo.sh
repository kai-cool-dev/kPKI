#!/bin/bash
# Generiert ein neues SSL File basierend auf einem CSR
POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
    -c|--cert)
      CERT="$2"
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

if [ "$CERT" == "" ]
then
  echo "Parameter -c/--cert <path/to/cert.pem> missing!"
  exit 1
fi
if ! [ -f "$CERT" ]
then
  echo "Path to cert.pem not valid!"
  exit 1
fi

CERTDATA=$(cat "$CERT" | sed -E ':a;N;$!ba;s/\r{0,1}\n/\\n/g')
JSON="{\"certificate\": \"$CERTDATA\"}"
CURLDATA=$(curl --silent -d "$JSON" localhost:8888/api/v1/cfssl/certinfo)
if [ "$CURLDATA" == "" ]
then
  echo "Error in CURL: $CURLDATA"
  exit 1
fi
echo -e "###################################################"
echo "$CURLDATA" | jq '.'
echo -e "###################################################"
