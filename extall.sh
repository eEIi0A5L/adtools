#!/bin/bash
# フィルタのドメインがまだ生きているかチェックする
# →もう死んでるサイトはフィルタを削除する

/bin/rm all
DIR=../adblock_filter
for i in $DIR/*.txt; do
	echo $i | tee -a all
	./extdomain.sh $i | tee -a all
	./conn.sh | tee -a all
done
