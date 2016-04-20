#!/bin/bash
### This script gets latest version ###
### of cisco config file and push   ###
### it to git if there are any      ###
### differencies found              ###
### Author: Elias Nichupienko       ###
### Usage: cisco.sh login pass host ###

today=`date +%Y%m%d`
ciscoName="cat7604"
workdir=/backup
user=$1
pass=$2
host=$3
config="config"

cd $workdir

dowlonad(){
	lftp -u $user,$pass ftp://$host <<EOF
	get $config
	bye
EOF
	mv config $ciscoName$today
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
