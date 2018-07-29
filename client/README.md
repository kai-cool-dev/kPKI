## kPKI client

This are the files for the kPKI client. It is basically a bash script which generates a CSR in JSON file, sends it to the PKI daemon public hostname, the daemon generates the private and public key.

Notice: the private key is not saved in the PKI, if you loose it you need to revoke the certificate and generate a new one.

## Installation:

1. Copy this files to /opt/kpki on your client computer/server
2. Install go or copy the complete go folder to /usr/local/ (the standard installation path)
4. run kpkiclient.sh

## Configuration / Automatisation:

You can edit `kpkiclient.sh` and fill out following variables for standard input:

```
CERT_O="" # Your Organisation
CERT_U="" # Organisation Unit
CERT_L="" # Locality of your Organisation
CERT_ST="" # State of your Organisation
CERT_C="" # Country of your Organisation
```

If you leave this variables empty, the client asks for these details.
