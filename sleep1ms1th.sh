#! /bin/bash
for i in {1..10}
do
    echo $i
    time swift -tc.file tc.data -sites.file 1-throttle-sites.xml sleep.swift -sleeptime=10000
done