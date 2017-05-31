printf "\n\n##### Beginning 02300-install-redis.sh\n\n" >> /root/report/build-report.txt

printf "\n## INSTALL REDIS CACHE\n\n"

cd /opt

wget http://download.redis.io/redis-stable.tar.gz

tar xvzf redis-stable.tar.gz

rm /opt/redis-stable.tar.gz

cd redis-stable

make

mkdir /etc/redis

mkdir /var/redis

cp /opt/redis-stable/utils/redis_init_script /etc/init.d/redis_6379

# ToDo: write a correct conf file
cp /opt/redis-stable/redis.conf /etc/redis/6379.conf

mkdir /var/redis/6379

update-rc.d redis_6379 defaults

#/etc/init.d/redis_6379 start

systemctl start redis_6379
