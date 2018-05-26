#!/bin/bash
/pki/client/cfssl ocspdump -db-config /pki/conf/config_mysql.json > /pki/client/ocspdump.txt
systemctl restart ocsp.service
systemctl status ocsp.service
