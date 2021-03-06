#!/bin/sh

export http_proxy="http://127.0.0.1:8001/"
export HTTP_PROXY="http://127.0.0.1:8001/"
export https_proxy="http://127.0.0.1:8001/"
export HTTPS_PROXY="http://127.0.0.1:8001/"

curl https://ifconfig.co/json
