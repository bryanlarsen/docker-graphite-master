#!/usr/bin/env python

# from http://stackoverflow.com/questions/6244382/how-to-automate-createsuperuser-on-django

import os

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "graphite.settings")
from django.conf import settings

from django.contrib.auth.models import User

u = User(username='admin')
u.set_password('admin')
u.is_superuser = True
u.is_staff = True
u.save()
