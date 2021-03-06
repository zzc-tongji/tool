#!/bin/sh
set -e
set -x

# work directory
SCRIPT_PATH=`cd "$(dirname "$0")"; pwd -P`
cd $SCRIPT_PATH

# clean
rm -fr *.pem

# CA
openssl genrsa 4096 > ca-key.pem
openssl req -sha1 -x509 -nodes -days 3650 -key ca-key.pem -subj /CN=ca> ca-cert.pem

# server
openssl req -sha1 -newkey rsa:4096 -days 3650 -nodes -keyout server-key.pem -subj /CN=server > server-req.pem
openssl rsa -in server-key.pem -out server-key.pem
openssl x509 -sha1 -req -in server-req.pem -days 3650 -CA ca-cert.pem -CAkey ca-key.pem -set_serial 01 > server-cert.pem
openssl verify -CAfile ca-cert.pem server-cert.pem

# client
openssl req -sha1 -newkey rsa:4096 -days 3650 -nodes -keyout client-key.pem -subj /CN=client > client-req.pem
openssl rsa -in client-key.pem -out client-key.pem
openssl x509 -sha1 -req -in client-req.pem -days 3650 -CA ca-cert.pem -CAkey ca-key.pem -set_serial 01 > client-cert.pem
openssl verify -CAfile ca-cert.pem client-cert.pem

# permission
chmod 644 *.pem
echo OK
