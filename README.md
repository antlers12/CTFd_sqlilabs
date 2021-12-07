# 适用于CTFd的sqlibs动态Flag镜像生成

本项目以sqlibs的Less-5题为例，容器内其他题目无法使用，你可以通过修改Dockerfile文件自行修改为其他题目。



## 特点

支持CTFd动态Flag，其中Flag被放置在security库下以`flag`开头的随机表名的表中。



## 使用方法

### 1.自由部署

git项目到本地

```
sudo git clone https://github.com/antlers12/CTFd_sqlilabs.git
```

下载后可以自由更改对应的配置，可以修改`Dockerfile`、`docker-compose.yml`、`start.sh`、`flag.sql`文件，如果需要更改Mysql密码，还需要到src源码下的sql-connections/db-creds.inc中修改

其中的`Antlers12`字符是用来替换动态Flag的，如果要进行修改，需要手动将全部的字符替换。

手动配置完成后，就可以生成docker镜像并启动，默认外部8023端口映射容器80端口

```
sudo docker-compose up -d
```

查看docker生成的镜像

```
sudo docker images
```



### 2.直接部署

如果嫌麻烦的话，可以直接用我在dockerhub已经打包好的镜像进行题目构建，只需要编写`Dockerfile`和`docker-compose.yml`就好了

**Dockerfile**

```Dockerfile
FROM antlers12/base_ctfd_sqlibs

ENV LANG C.UTF-8

# 选择构建第几题的镜像，这里举例第3题
RUN mv /var/www/html/Less-3 /var/www/html/LessTemp
RUN rm -rf /var/www/html/Less-*
RUN mv /var/www/html/LessTemp /var/www/html/Less-3
RUN sed -i '27 a <script type="text/javascript">window.location.href="./Less-3";</script>' /var/www/html/index.html


EXPOSE 80 3306
```

**docker-compose.yml**

```
version: '2'
services:
 web:
# 设置生成的镜像名
  image: ctfd_sqlibs-3
  build: .
# 设置环境变量，用于生成动态flag
  environment:
   - FLAG=Antlers12
# 设置映射端口
  ports: 
   - "8089:80"
# 设置容器总是重新启动
  restart: always
```

当前文件夹下输入以下命令启动

```
sudo docker-compose up -d
```

查看docker生成的镜像

```
sudo docker images
```

