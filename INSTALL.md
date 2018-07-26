## How to install everything?

You can use our bash installer for preparing the config files and csr requests. For manual installation please read `docs/manual-install.md`

## Prerequisites

- working MySQL or MariaDB server
- working Nginx or Apache Webserver with PHP 7.2 and Phalcon-PHP Framework (Please read `html/README.md` for further instructions)

## Bash Installer:

You can find the bash installer under `install/install.sh`.

If you execute the installer we ask for a few things required to run your PKI

- public Hostname/IP for the PKI Daemon
This is the hostname/ip for the pki daemon. This needs to be available to all clients which shoudl interact with your PKI. For example the client for server and the gui. The daemon is always started at Port 8888 no matter what you type in there.

- public Hostname/IP for the OCSP Daemon
This ist the hostname/ip for the ocsp daemon. It should be available to all clients which check for ocsp responses (e.g. browsers)

- mysql host
This is the mysql database server hostname or ip

- mysql port
This is the port your mysql database server runs (default 3306)

- mysql username
self explaining

- mysql password
self explaining
