#!/bin/bash
echo "Starting"
/pki/client/cfssl serve -db-config=/pki/conf/config_mysql.json -loglevel=0 -ca-key=/pki/certs/intermediate/intermediate.key.pem -ca=/pki/certs/intermediate/intermediate.crt.pem -config=/pki/conf/config_ca.json -responder=/pki/ocsp/server-ocsp.pem -responder-key=/pki/ocsp/server-ocsp-key.pem
