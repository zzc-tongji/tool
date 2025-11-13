#!/bin/bash

cd /media
find . -mindepth 1 -maxdepth 1 -type d -exec echo {} \; | while read LINE ; do sudo umount ${LINE}; done
