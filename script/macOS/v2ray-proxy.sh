#!/bin/sh

export http_proxy="http://127.0.0.1:8001/"
export https_proxy="http://127.0.0.1:8001/"
export HTTP_PROXY="http://127.0.0.1:8001/"
export HTTPS_PROXY="http://127.0.0.1:8001/"

curl -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.190 Safari/537.36" https://ifconfig.co/json

