#!/bin/bash
# フィルタのdiffをとる
FILE1=$1
FILE2=$2
IFS=$'\n'

function main() {
    readarray lines1 < $FILE1
    readarray lines2 < $FILE2
    for e1 in ${lines1[@]}; do
        echo "e1=$e1"
        if [[ "$e1" =~ ^[\[!] ]]; then
            continue
        fi

        for e2 in ${lines2[@]}; do
            #echo "e2=$e2"
            if [[ "$e2" =~ ^\[ ]]; then
                continue
            fi

            if [ "$e1" = "$e2" ]; then
                echo $e1
            fi
        done
    done
}
main
