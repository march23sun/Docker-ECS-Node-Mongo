#!/bin/sh

if [ "${S3_ACCESS_KEY_ID}" = "**None**" ]; then
  echo "You need to set the S3_ACCESS_KEY_ID environment variable."
  exit 1
fi

if [ "${S3_SECRET_ACCESS_KEY}" = "**None**" ]; then
  echo "You need to set the S3_SECRET_ACCESS_KEY environment variable."
  exit 1
fi

if [ "${S3_BUCKET}" = "**None**" ]; then
  echo "You need to set the S3_BUCKET environment variable."
  exit 1
fi

if [ "${CRONTAB_SETTING}" = "**None**" ]; then
  echo "You need to set the CRONTAB_SETTING environment variable."
  exit 1
fi

echo "access_key=$S3_ACCESS_KEY_ID" >> /root/.s3cfg
echo "secret_key=$S3_SECRET_ACCESS_KEY" >> /root/.s3cfg
echo "host_bucket=$S3_BUCKET" >> /root/.s3cfg
echo "bucket_location=$S3_REGION" >> /root/.s3cfg

cp /code/checkCodeCommit.sh /node/checkCodeCommit.sh
chmod +x /node/checkCodeCommit.sh
echo "**init**" > /node/codecommit.flag

expect -f /code/codecommit.sh

echo "deploy __ `date +"%b_%d_%Y_%H.%M.%S"`">> /node/src/public/logs/log.txt
echo **aws shell done.**
echo **done** > /node/codecommit.flag

crontab -r
#write crontab
(crontab -l 2>/dev/null; echo "$CRONTAB_SETTING mongodump -u=$MONGO_USER -p=$MONGO_PWD --authenticationDatabase admin --authenticationMechanism SCRAM-SHA-1 -h mongo-container --db local --gzip --archive=/s3backup/mongodump.temp.archive.gz  1>> /node/src/public/logs/log.txt 2>> /node/src/public/logs/log.txt && /code/movefile.sh  && /usr/local/bin/s3cmd sync /s3backup s3://$S3_BUCKET/ 1>> /node/src/public/logs/log.txt 2>> /node/src/public/logs/log.txt") | crontab - 
crontab -l
service cron start

tail -f /dev/null
