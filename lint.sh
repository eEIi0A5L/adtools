#!/bin/bash

function lint()
{
	FILE=$1
	echo $FILE
	while IFS=$'\r' read line; do
		regexp="[ ]*!"
		if [[ $line =~ $regexp ]]; then
			continue
		fi
		
		# empty line
		if [[ $line =~ ^$ ]]; then
			continue
		fi

		# cosmetic filter
		regexp="#@?#."
		if [[ $line =~ $regexp ]]; then
			continue
		fi
		regexp="#@?##"
		if [[ $line =~ $regexp ]]; then
			continue
		fi

		# network filter
		if [[ $line =~ ^\|\| ]]; then
			continue
		fi
		if [[ $line =~ ^@@\|\| ]]; then
			continue
		fi

		echo $line
	done < $FILE
}

function main()
{
	FILE=$1
	lint $FILE
}

main $*

