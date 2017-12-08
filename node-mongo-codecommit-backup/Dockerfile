FROM ubuntu
MAINTAINER march23sun
RUN apt-get update && apt-get install cron  python-pip   lsb-release vim -y

RUN pip install s3cmd
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
RUN echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-3.4.list
RUN apt-get update && apt-get install mongodb-org-tools=3.4.10 -y
RUN apt-get update && apt-get install git expect -y

COPY ./code/aws.sh /usr/local/bin/aws.sh
COPY ./code/movefile.sh /code/movefile.sh
COPY ./code/s3cfg /root/.s3cfg
COPY ./code/codecommit.sh /code/codecommit.sh
COPY ./code/checkCodeCommit.sh /code/checkCodeCommit.sh

RUN mkdir s3backup
ENV S3_ACCESS_KEY_ID **None**
ENV S3_SECRET_ACCESS_KEY **None**
ENV S3_BUCKET **None**
ENV S3_REGION ap-northeast-1
ENV CODECOMMIT_USER **None**
ENV CODECOMMIT_USER **None**
ENV CODECOMMIT_PWD **None**
ENV CODECOMMIT_REGION ap-northeast-1
ENV CODECOMMIT_NAME **None**
ENV CRONTAB_SETTING **None**
RUN chmod +x /usr/local/bin/aws.sh
RUN chmod a+x /code/movefile.sh
RUN chmod a+x /code/codecommit.sh

ENTRYPOINT "aws.sh"
CMD [""]
