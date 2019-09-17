#!/bin/bash
# check connectivity that a domain is on or off

function check()
{
    site=$1
    echo $site
    curl -s -I -m 5 $site -o /dev/null
    result=$?
    echo $result
    if [ $result -ne 0 ]; then
        echo "ERROR: $site"
    fi
}

function make_domain_list() {
    echo "make_domain_list start!"
    FILE=$1
    array=()


    if [ -e tmp ]; then
        rm tmp
    fi
    if [ -e comainlist ]; then
        rm comainlist
    fi
    while read line; do
        if [[ $line =~ ^! ]]; then
            continue
        fi
        if [[ ! $line =~ \#\# ]]; then
            continue
        fi
        echo $line

        domain_part=${line%%\#\#*}
        echo "domain_part=$domain_part"

        cosmetic_part=${line##*\#\#}
        echo "cosmetic_part=$cosmetic_part"

        arr=( `echo $domain_part | tr -s ',' ' '`)
        for i in ${arr[@]}; do
            echo $i
            domain=$i
            if [[ $i =~ ~(.*) ]]; then
                domain=${BASH_REMATCH[1]}
            fi
            echo $domain
            echo $domain >> tmp
        done
        #domain="$domain_part"
        #array+=("$domain")
    done < $FILE
    if [ ! -e tmp ]; then
        return
    fi

    cat tmp | sort | uniq > domainlist

    while read line; do
        domain=$line
        array+=("$domain")
    done < domainlist


    #domain="yahoo.co.jp"
    #array+=("$domain")
    #echo "array=$array"
    #domain="damage0.com"
    #echo "domain=$domain"
    #array+=("$domain")
    #array+=("aaa")
    #echo "array2=${array[@]}"
    #echo $array
    echo ${array[@]}
}

function main() {
    echo "main start!"
    FILE=$1
    #FILE=a.txt
    #FILE=../adfilters/280blocker_adblock.txt
    #FILE=../adblock_filter/mochi_filter_2gun.txt
    #FILE=../adblock_filter/mochi_filter.txt
    #FILE=../adblock_filter/mochi_filter_extended.txt
    #FILE=../adblock_filter/negi_filter.txt
    #FILE=../adblock_filter/tamago_filter.txt
    list=`make_domain_list $FILE`
    #echo ${list[@]}
    for i in ${list[@]}; do
        echo $i
        #check $i
    done
}

#check yahoo.co.jp
#check damage0.com
if [ "$1" = "" ]; then
    echo "Usage: extdomain.sh <filename>"
    exit 1
fi

main $1

# End of file

