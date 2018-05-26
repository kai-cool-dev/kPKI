#!/bin/bash
echo "Starting"
/root/go/bin/cfssl serve -db-config=/pki/conf/config_mysql.json -loglevel=0 -ca-key=/pki/certs/kainet/ca-server-key.pem -ca=/pki/certs/kainet/ca-server.pem -config=/pki/conf/config_ca.json -responder=/pki/ocsp/server-ocsp.pem -responder-key=/pki/ocsp/server-ocsp-key.pem
