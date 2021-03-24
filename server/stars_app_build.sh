#!/bin/bash

echo "Building STARS App ..."
echo "JOBID: $1";
rm /stars-collaborate-master/apps/job/stars.cpp
cp /server/out/$1/$1.cc /stars-collaborate-master/apps/job/stars.cpp
cd /stars-collaborate-master
rm -rf output/*
rm -rf analysis/*
cd build
cmake ..
make
cd ..
./build/apps/job/stars.out
cp /translator/plot_testing.py ./util/
./util/plot_testing.py
cp output/events.txt /server/out/$1/events.txt
cp output/data.nc4 /server/out/$1/data.nc4
zip -r /server/out/$1/data.zip output
rm -rf output/*
cp analysis/* /server/out/$1/
zip -r /server/out/$1/analysis.zip analysis/*.png
rm -rf analysis/*
cd /server          
