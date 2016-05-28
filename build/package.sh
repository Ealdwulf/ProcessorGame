#!/bin/sh
mkdir -p ../bin
rm ../bin/processor.love
mkdir temp
cp -r ../src/* temp/
cp -r ../res temp/
(cd temp; zip -9 -q -r ../../bin/processor.love .)
rm -rf temp
