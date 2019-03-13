#!/bin/sh

/bin/rm -f result

DIR=../adblock_filter
for i in $DIR/*.txt; do
	#echo $i | grep "Adblock_Plus_list" > /dev/null 2>&1
	#if [ $? -eq 0 ]; then
	#	continue
	#fi
	echo $i
	#python3 f2h.py $i >> result
	./cosmetic.sh $i >> result
done

sort result | uniq > a


