#!/bin/bash
### This script gets latest version of cisco config file and push it to git if there are any differencies found ###
### Author: Elias Nichupienko ###

today=`date +%Y%m%d`
ciscoName="cat7604"
workdir=/backup

cd $workdir

dowlonad(){
	download > $ciscoName$today
}

compare(){
	old=`find $workdir -mindepth 1 -maxdepth 1 -type f -name "*$ciscoName*" | sort -n | tail -1`
	ALLDIFFS=`diff $old $ciscoName$today`
    if [[ -n $ALLDIFFS ]]; then
    	git add $ciscoName$today
    	git commit -m "Daily update: new config by $today"
    	git push
    	rm $old
    else
    	echo "No any new data"
    fi

}

rm $ciscoName$today
download
compare

exit 0
