## graphite install script
#!/bin/bash

## prereqs

yum install -y git python  python-devel pycairo mod_python python-memcached python-sqlite
##yum install gcc make 
yum install -y mod_wsgi

easy_install pip
easy_install txamqp
easy_install twisted
pip install django-tagging

cd /tmp
wget http://deploy01.ops/ops/Django-1.3.4.tar.gz
tar -zxvf Django-1.3.4.tar.gz
cd Django-1.3.4

python setup.py install

# 0.9.10  branch
cd /opt/
git clone https://github.com/graphite-project/graphite-web.git
cd graphite-web
git checkout 0.9.10
cd ..
git clone https://github.com/graphite-project/carbon.git
cd carbon
git checkout 0.9.10
cd ..
git clone https://github.com/graphite-project/whisper.git
cd whisper
git checkout 0.9.10
cd ..

## whisper install
pushd whisper
sudo python setup.py install
popd

## carbon install
pushd carbon
python setup.py install 
popd

## configure carbon
pushd /opt/graphite/conf
cp carbon.conf.example carbon.conf
cp storage-schemas.conf.example storage-schemas.conf

## data retention
#[everything_1min_13months]
#priority = 100
#pattern = .*
#retentions = 1m:395d

vi /opt/graphite/conf/storage-schemas.conf

## start carbon
/opt/graphite/bin/carbon-cache.py  start

## install graphite
cd /opt
pushd graphite-web
python setup.py install
popd

## whisper db creation
cd /opt/graphite/webapp/graphite
sudo python manage.py syncdb

chown apache:apache /opt/graphite/storage/graphite.db

cd /opt/graphite/webapp/graphite
cp local_settings.py.example local_settings.py

## local_settings.py
## uncomment DEBUG = True

##
#DATABASES = {
#‘default’: {
#‘NAME’: ‘/opt/graphite/storage/graphite.db’,
#‘ENGINE’: ‘django.db.backends.sqlite3′,
#‘USER’: ”,
#‘PASSWORD’: ”,
#‘HOST’: ”,
#‘PORT’: ”
#}
#}
vi /opt/graphite/webapp/graphite/local_settings.py

## configure apache
cp /opt/graphite/examples/example-graphite-vhost.conf /etc/httpd/conf.d/graphite.conf
cp /opt/graphite/conf/graphite.wsgi.example /opt/graphite/conf/graphite.wsgi
chown apache:apache /opt/graphite/storage
chown -R apache:apache /opt/graphite/storage/log/

## start apache
service httpd restart
