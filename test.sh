#! /bin/bash                                                                                                                                                                                               
throttle=1
# 1 through 8 for the sleeptimes
for i in {1..8}
do
sleeptime=100
    # 1 through 5 for the throttles
    for k in {1..5}
    do
	echo "Throttle count equals: " $throttle    
	echo "Sleeptime is equal to: " $sleeptime
	
	# run swift
	# time swift -tc.file tc.data -sites.file $throttle-throttle-sites.xml sleep.swift -sleeptime=$sleeptime
	time swift -tc.file tc.data -sites.file 1-throttle-sites.xml sleep.swift -sleeptime=1000

        # double the sleeptime
	sleeptime=$(expr $sleeptime + $sleeptime)
    done
# double the throttle
throttle=$(expr $throttle + $throttle)
done