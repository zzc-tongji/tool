#!/bin/sh

export http_proxy=
export https_proxy=
export HTTP_PROXY=
export HTTPS_PROXY=

curl -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.190 Safari/537.36" https://ifconfig.co/json

