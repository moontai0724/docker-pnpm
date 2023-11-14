#!/bin/sh

if [ -f "/etc/debian_version" ]; then
    apt-get update && apt-get install -y wget;
elif [ -f "/etc/redhat-release" ]; then
    yum install -y wget;
elif [ -f "/etc/alpine-release" ]; then
    apk --no-cache add wget;
else
    echo "Unsupported base image";
    exit 1;
fi
