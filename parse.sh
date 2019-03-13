#!/bin/bash
# parse filter

function parse() {
	echo "parse start!"
	FILE=$1


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

		cosmetic_css_part=${cosmetic_part%%\$*}
		cosmetic_param_part=${cosmetic_part##*\$}
		echo "cosmetic_css_part=$cosmetic_css_part"
		echo "cosmetic_param_part=$cosmetic_param_part"
		

	done < $FILE
}

function main() {
	echo "main start!"
	FILE=$1
	parse $FILE
}

if [ "$1" = "" ]; then
	echo "Usage: extdomain.sh <filename>"
	exit 1
fi

main $1

# End of file

