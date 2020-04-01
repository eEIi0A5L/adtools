#!/bin/bash

FILE=$1
if [ "$FILE" = "" ]; then
    echo "Usage: ubo2pihole.sh <ubofile>"
    exit 1
fi

while read line; do
done < $FILE

