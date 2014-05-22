#!/bin/bash

set -e

if [ ! -z $SECRET_KEY ]; then
  sed -E -i "s/^environment = (.*)$/environment = \1,SECRET_KEY='$SECRET_KEY'/" /usr/local/etc/supervisord.conf
fi

/usr/local/bin/supervisord
