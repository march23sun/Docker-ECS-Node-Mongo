#!/usr/bin/bash
echo **shell code commit start**
while [ ! -d /app ] || [ ! -e /app/codecommit.flag ] || [ "$(head -n 1 /app/codecommit.flag)" = "**init**" ];
do
echo Waitting CodeCommit Deploy procedure...
sleep 10
done

cd /app/src
npm install 
npm start
echo "**init**" > /node/codecommit.flag