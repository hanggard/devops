#!/bin/bash
export workdir=`dirname $0`
export LANG=en_US.UTF8
date=`date --date "Next Year" +%a", "%d" "%b" "%Y" "%T" GMT"`
for file in `cat $workdir/gziplist`; do
dir=`dirname $file`
filename=`basename $file`
relname=`echo $dir | cut -d'/' -f6-`

diff <(zcat $file.gzip) <(cat $file) > /dev/null
retval=$?
echo retval=$retval
if [[ $retval = 0 ]]
then
    :
else
    cat $file | gzip -9 > $dir/$filename.gzip
fi
eval aws s3 sync --include "*.js.gzip" --expires '"$date"' --cache-control "public" --content-type "application/x-javascript" --content-encoding "gzip" $dir/ s3://bucket-static/$relname #> /dev/null
done
