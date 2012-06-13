#! /bin/bash
j=100
for i in {1..8}
do
    echo $i
    $j = $(expr $j + $j)
    echo $j
done
