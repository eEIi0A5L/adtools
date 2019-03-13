#!/bin/bash

FILE=android_filterproxy

while read line; do
	#echo $line

	if [[ $line =~ ^$ ]]; then
		continue
	fi
	if [[ $line =~ ^# ]]; then
		continue
	fi
	# counterはよくわからないのでパス
	if [[ $line =~ /counter/ ]]; then
		continue
	fi
	#amazonはやめとく
	if [[ $line =~ amazon ]]; then
		continue
	fi
	#googleショッピングで商品をクリックしても飛ばない
	#http://egg.5ch.net/test/read.cgi/software/1540428057/406
	if [[ $line =~ www.googleadservices.com ]]; then
		continue
	fi
	#チャンネルページトップのメンバーのチャンネルのサムネイルが表示されない
	if [[ $line =~ yt3.ggpht.com ]]; then
		continue
	fi

	# suffix
	suffix=""
	if [[ $line =~ doubleclick.net ]]; then
		suffix="\$third-party"
	fi


	tmp=${line%/}
	echo "||$tmp^$suffix"
done < $FILE

