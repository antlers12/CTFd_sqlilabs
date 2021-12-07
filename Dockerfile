FROM ubuntu:14.04

ENV LANG C.UTF-8
# 更换源
RUN sed -i 's/http:\/\/archive.ubuntu.com\/ubuntu\//http:\/\/mirrors.163.com\/ubuntu\//g' /etc/apt/sources.list
# 更新
RUN apt-get update -y
# 防止Apache安装过程中地区的设置出错
ENV DEBIAN_FRONTEND noninteractive

# 安装mysql
RUN apt-get -y install mysql-server
# 安装apache2
RUN apt-get -yqq install apache2
# 安装php5
RUN apt-get -yqq install php5 libapache2-mod-php5
# 安装php扩展
RUN apt-get install -yqq php5-mysql php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-ming php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl
# 安装其他所需组件
RUN apt-get install -yqq vim curl


# 复制本地src文件夹下的文件到apache的网站目录,可以设置生成第几题，这里以第5题为例
COPY ./src /var/www/html
RUN rm -rf /var/www/html/Less-*
COPY ./src/Less-5 /var/www/html/Less-5
RUN sed -i '27 a <script type="text/javascript">window.location.href="./Less-5";</script>' /var/www/html/index.html
RUN chmod 777 /var/www/html
# 复制脚本到root目录下再给权限
COPY flag.sql /root/flag.sql
COPY start.sh /root/start.sh
RUN chmod +x /root/start.sh


RUN chown -R mysql:mysql /var/lib/mysql&&\
    # 修改secure_file_priv,可以指定sqlibs题目
    sed -i  "N;32a\secure_file_priv=/var/www/html" /etc/mysql/my.cnf&&\
    find /var/lib/mysql -type f -exec touch {} \; && service mysql start &&\
    # 修改root密码为“toor”,如果要修改密码,需要同时修改sqlibs源码下sql-connections/db-creds.inc中的密码,配置Apache信息
    mysqladmin -uroot password toor&&\ 
    sed -i '$a\ServerName 127.0.0.1'  /etc/apache2/apache2.conf&&service apache2 restart&&\
    sed -i 's/Options Indexes FollowSymLinks/Options None/' /etc/apache2/apache2.conf

EXPOSE 80 3306

# 在容器生成时候，启动start.sh脚本
ENTRYPOINT ["/root/start.sh"]