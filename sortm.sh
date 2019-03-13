#!/bin/sh
#文字数でソートする

FILE=$1

cat $FILE | awk '{print length($0), $0}' | sort -nr | cut -d' ' -f2-
