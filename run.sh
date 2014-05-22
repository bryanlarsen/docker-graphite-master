#!/bin/bash

set -e
if [ ! -z $SECRET_KEY ]; then
  sed -E -i "s/^environment = (.*)$/environment = \1,SECRET_KEY='$SECRET_KEY'/" /usr/local/etc/supervisord.conf
fi

if [ ! -f /opt/graphite/storage/graphite.db ]; then
  mkdir -p /opt/graphite/storage/log/webapp
  mkdir -p /opt/graphite/storage/whisper
  touch /opt/graphite/storage/graphite.db /opt/graphite/storage/index /opt/graphite/storage/log/webapp/info.log /opt/graphite/storage/log/webapp/exception.log
  chown -R www-data /opt/graphite/storage
  chmod 0775 /opt/graphite/storage /opt/graphite/storage/whisper
  chmod 0664 /opt/graphite/storage/graphite.db
  PYTHONPATH=/opt/graphite/webapp django-admin.py syncdb --settings=graphite.settings --noinput
  PYTHONPATH=/opt/graphite/webapp python /opt/graphite/webapp/graphite/create_superuser.py
fi

/usr/local/bin/supervisord
