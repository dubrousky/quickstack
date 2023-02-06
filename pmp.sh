#!/bin/bash
nsamples=10
sleeptime=0
pid=$(/sbin/pidof $1)
getstack='gdb -ex "set pagination 0" -ex "thread apply all bt" --batch -p '"$pid"
getstack="./quickstack -p $pid"
sep=';'

for x in $(seq 1 $nsamples)
do
    eval $getstack
    sleep $sleeptime
done | \
awk '
  BEGIN { s = ""; } 
  /^Thread/ { print s; s = ""; } 
  /^\#/ { if (s != "" ) { s = $4 ";" s} else { s = $4 } } 
  END { print s }' | \
sort | uniq -c| sort -r -n -k 1,1|awk '{print $2" "$1}' 
