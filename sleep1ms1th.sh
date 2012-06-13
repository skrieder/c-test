#! /bin/bash
for i in {1..5}
do
    echo $i
    time swift -tc.file tc.data -sites.file 1-throttle-sites.xml sleep1ms.swift
done