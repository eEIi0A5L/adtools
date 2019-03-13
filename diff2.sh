#!/bin/bash
#フィルタのdiffをとる

function usage() {
	echo "Usage: diff2.sh <file1> <file2>"
}

function make_sorted() {
	INPUT_FILE=$1
	OUTPUT_FILE=$2
	sort $INPUT_FILE | grep -v "!" > $OUTPUT_FILE
}

FILE1=$1
FILE2=$2
if [ "$FILE1" = "" ]; then
	usage
	exit 1
fi
if [ "$FILE2" = "" ]; then
	usage
	exit 1
fi

SORTED1=/tmp/.sorted1
SORTED2=/tmp/.sorted2

make_sorted $FILE1 $SORTED1
make_sorted $FILE2 $SORTED2

diff -u $SORTED1 $SORTED2

# EOF

