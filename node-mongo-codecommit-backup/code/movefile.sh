#!/bin/sh
mv "/s3backup/mongodump.temp.archive.gz" "/s3backup/`date '+%FT%H-%M-%S-%Z'`.archive.gz" 