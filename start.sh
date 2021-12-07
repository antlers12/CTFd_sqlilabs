#!/bin/bash

# 启动服务，例如apache2
# 具体的启动命令，视系统环境而定
/etc/init.d/apache2 start
# 为了适应各种docker版本，mysql的启动命令建议如下（mysqld除外）
find /var/lib/mysql -type f -exec touch {} \; && service mysql start

# 设置动态flag,同时随机flag的表名和字段名
sed -i "s/Antlers12/$FLAG/g" /root/flag.sql
sed -i "s/2333/$RANDOM/g" /root/flag.sql

# 初始化sqlibs
curl http://127.0.0.1/sql-connections/setup-db.php
mysql -uroot -ptoor security < /root/flag.sql

# rm /var/www/html/sql-lab.sql
export FLAG=not_flag
FLAG=not_flag
killall mysqld_safe

supervisord -n
tail -F /dev/null