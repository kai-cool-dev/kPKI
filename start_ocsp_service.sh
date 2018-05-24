#!/bin/bash
/root/go/bin/cfssl ocspserve -port=8889 -responses=/pki/ocspdump.txt  -loglevel=0
