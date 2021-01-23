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
cp output/* /server/out/$1/
rm -rf output/*
cp analysis/* /server/out/$1/
rm -rf analysis/*
cd /server          
