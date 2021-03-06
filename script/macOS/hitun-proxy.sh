#!/bin/sh

export http_proxy="http://127.0.0.1:4780/"
export HTTP_PROXY="http://127.0.0.1:4780/"
export https_proxy="http://127.0.0.1:4780/"
export HTTPS_PROXY="http://127.0.0.1:4780/"

curl https://ifconfig.co/json
