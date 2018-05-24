#!/bin/sh
ISSUER_CER=$1
SERVER_CER=$2

URL=$(openssl x509 -in $SERVER_CER -text | grep "OCSP - URI:" | cut -d: -f2,3)

openssl ocsp -noverify -no_nonce -respout ocsp.resp -issuer $ISSUER_CER -cert $SERVER_CER -url $URL
