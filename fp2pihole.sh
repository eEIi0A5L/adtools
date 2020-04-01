#!/bin/bash
# filterproxyのdenylistをpihole用に変換する

FILE=android_filterproxy
while IFS=$'\r' read line; do
    #echo "$line"
    if [[ $line =~ ^$ ]]; then
        continue
    fi
    if [[ $line =~ ^# ]]; then
        continue
    fi
    if [[ ! $line =~ \. ]]; then
        continue
    fi
    if [[ $line =~ \/[a-z0-9] ]]; then
        continue
    fi
    if [[ $line =~ ^\.(.*) ]]; then
        line=${BASH_REMATCH[1]}
    fi
    #echo "$line"
    if [[ $line =~ (.*)\/ ]]; then
        line=${BASH_REMATCH[1]}
    fi
    echo "$line"
done < $FILE

