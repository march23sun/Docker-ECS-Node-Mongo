## Docker-ECS-Node-Mongo

定義一個AWS + Node.js + mongoDB的多容器 Docker app並可在AWS Elastic Beanstalk (Multi-container Docker) 環境部屬，除了提供基礎的nodejs + mongoDB 執行環境，並加上以下特性：
+ 將Nodejs Source 及 mongo DBdata 分別存放於獨立的 Dara Volumes 將執行環境與程式碼/資料分隔
+ 使用Crontab排程定期備份mongo DBdata到AWS S3
+ 使用AWS Codecommit部屬/更新Node.js source

*第一次摸索shell & Docker掌握程度不高任何不完善部分懇還請指教修正*

>Amazon Web Services
 + Elastic Container Service 
 + Elastic Beanstalk
 + S3
 + CodeCommit

>Docker Image
+ node:8.9-alpine
+ mongo:3.4.10
+ ubuntu

> Docker-Compose

### Deploty to AWS  Elastic Beanstalk

1.建立一個CodeCommit  Repository
 + Push Node.js Source 到 CodeCommit  Repository
 
2.建立一個MongoDB 備份存放的 S3 bucket
3.建一個 ECS Repository 
+ Push 自定義Docker Image  到ECS Repository 

```bash
#完整指令可在ECS後台直接產出
$ docker build -t <YOUR Repository name> .
$ docker tag <YOUR Repository name>:版本號 <Repository URI>:版本號
$ docker push <Repository URI>:版本號
#如果遇到no basic auth credentials 使用以下指令：
$ eval $(aws ecr get-login | sed 's|https://||')
```

4.使用 micahhausler/container-transform 將docker-compose.yml 轉譯為 Dockerrun.aws.json
```bash
$ sudo bash -c  "cat docker-compose.yml | docker run --rm -i micahhausler/container-transform >> Dockerrun.aws.json"
```
+ 轉譯後特別注意要加上AWSEBDockerrunVersion及 ECS Repository URI 
``` 
{
    "AWSEBDockerrunVersion": 2,
    "containerDefinitions": [
        {
	    "name": "res"
            "essential": true,
	    "image": "<ECS Repository URI>:版本號",
	    ...
        },
	...
    ],
...
}
```
5.將Dockerrun.aws.json打包zip檔 Deploy到EB

6.訪問 xxx.REGION.elasticbeanstalk.com 並使用Robo工具分別測試nodejs mongodb是否正常(須先將對應的EC2 inbound rules 新增mongodb port)
#### Update & Deploy Node Js Source Flow
1.commit & Push node.js source code to CodeCommit Repository 
2.重啟應用程序服務器

### Local

```
docker-compose up --build
```
