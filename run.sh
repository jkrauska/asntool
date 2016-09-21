#!/bin/bash

wd=`pwd`
mkdir -p ${wd}/data
docker run -it -v ${wd}/data:/data asn
