
FROM ubuntu:12.04

# install dependencies --------------------------------------------------------
RUN echo 'deb http://archive.ubuntu.com/ubuntu precise main universe' > /etc/apt/sources.list.d/universe.list
RUN apt-get -y update

RUN apt-get -y --force-yes install vim python-flup expect git memcached sqlite3 libcairo2 libcairo2-dev python-cairo pkg-config wget python-dev python-pip nginx-light

RUN pip install txAMQP

RUN pip install supervisor
RUN mkdir /var/log/supervisor

# # get source code -------------------------------------------------------------
RUN cd /usr/local/src && git clone https://github.com/graphite-project/graphite-web.git

RUN cd /usr/local/src && git clone https://github.com/graphite-project/whisper.git

RUN cd /usr/local/src && git clone https://github.com/graphite-project/carbon.git

# # install apps ----------------------------------------------------------------
RUN cd /usr/local/src/graphite-web && pip install -r requirements.txt && python ./setup.py install

RUN cd /usr/local/src/whisper && python ./setup.py install

RUN cd /usr/local/src/carbon && pip install -r requirements.txt && python ./setup.py install

RUN mkdir -p /opt/graphite/storage/log/webapp
RUN mkdir -p /opt/graphite/storage/whisper
RUN touch /opt/graphite/storage/graphite.db /opt/graphite/storage/index /opt/graphite/storage/log/webapp/info.log /opt/graphite/storage/log/webapp/exception.log
RUN chown -R www-data /opt/graphite/storage
RUN chmod 0775 /opt/graphite/storage /opt/graphite/storage/whisper
RUN chmod 0664 /opt/graphite/storage/graphite.db
RUN PYTHONPATH=/opt/graphite/webapp django-admin.py syncdb --settings=graphite.settings --noinput
# RUN PYTHONPATH=/opt/graphite/webapp django-admin.py createsuperuser --settings=graphite.settings --noinput --username=admin --email=admin@example.com

add ./nginx.conf /etc/nginx/nginx.conf
add ./supervisord.conf /usr/local/etc/supervisord.conf

# Add graphite config
add ./initial_data.json /opt/graphite/webapp/graphite/initial_data.json
add ./local_settings.py /opt/graphite/webapp/graphite/local_settings.py
add ./carbon.conf /opt/graphite/conf/carbon.conf
add ./storage-schemas.conf /opt/graphite/conf/storage-schemas.conf
add ./create_superuser.py /opt/graphite/webapp/graphite/create_superuser.py

RUN PYTHONPATH=/opt/graphite/webapp python /opt/graphite/webapp/graphite/create_superuser.py

add ./run.sh /run.sh
run chmod +x /run.sh


# Nginx
expose  80
# Carbon line receiver port
expose  2003
# Carbon pickle receiver port
expose  2004
# Carbon cache query port
expose  7002

volume ["/opt/graphite/storage"]

cmd ["/run.sh"]

