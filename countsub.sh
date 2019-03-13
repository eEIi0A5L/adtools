#!/bin/sh

FILE="$1"

# 空行マッチ: "^$" UNIXの場合
# Windowsの場合：grep -v -x -e ".$" /share/a.txt
grep -v -E "^!" $FILE | grep -v -x -e ".$" | grep -v -e "^|" | grep -v "##" | grep -v "#@#" | grep -v "domain=" | grep -v "\[Adblock" | grep -v -e "^@@" | grep -v -P "^\t" | grep -v -x -e "^$" | grep -v "#?#" | grep -v -e "|.$"
