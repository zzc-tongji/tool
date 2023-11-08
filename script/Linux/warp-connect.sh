#!/bin/sh

# Install WARP from "https://pkg.cloudflareclient.com/".
warp-cli register
warp-cli set-mode proxy
warp-cli connect
