#!/bin/bash
# domainlistの接続性チェック
# domainlistはextdomain.shで作成する

function check_ping() {
    domain=$1
    echo $domain
    ping -w 1 $domain > /dev/null 2>&1
    result=$?
    if [ $result -ne 0 ]; then
        echo "ERROR: $domain"
    fi
}

function check_curl() {
    domain=$1
    url_http="http://${domain}/"
    url_https="https://${domain}/"
    STATUS=`curl -m 5 -I $url_http -w '%{http_code}' -s -o /dev/null`
    if [ $STATUS -eq 200 ]; then
        return 0
    elif [ $STATUS -eq 301 -o $STATUS -eq 302 ]; then
        LOCATION=`curl -m 5 -I $url_http -w '%{redirect_url}' -s -o /dev/null`
        if [ "$LOCATION" = $url_https ]; then
            return 0
        else
            if [[ ! $LOCATION =~ $domain ]]; then
                echo $LOCATION
                return 2
            fi
        fi
    fi
    return 1
}

function check() {
    domain=$1
    echo $domain
    check_curl $domain
    result=$?
    if [ $result -eq 2 ]; then
        echo "===REDIRECT: $domain"
    elif [ $result -ne 0 ]; then
        # エラーならwwwをつけて試す、それでもだめならエラーとみなす
        wwwdomain="www.$domain"
        check_curl $wwwdomain
        result2=$?
        if [ $result2 -ne 0 ]; then
            echo "===ERROR: $domain"
        fi
    fi
}

function main() {
    FILE=domainlist
    while read line; do
        domain=$line
        check $domain
    done < $FILE
}

main
