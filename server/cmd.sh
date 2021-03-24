#!/bin/bash

#if [ -z "$S3_IAM_ACCESSKEY" ]
#then
#	echo "No S3 IAM Environment Variables Found"
#else
#	echo "Mounting S3 Bucket for GEOS-5 Data"
#	echo $S3_IAM_ACCESSKEY:$S3_IAM_SECRETKEY > ${HOME}/.passwd-s3fs
#	chmod 600 ${HOME}/.passwd-s3fs
#	s3fs stars-service-geos5 /stars-collaborate-master/input/nc4 -o passwd_file=${HOME}/.passwd-s3fs
#fi

echo "Running STARS REST Server"
exec python3 "/server/start_stars_server.py"

