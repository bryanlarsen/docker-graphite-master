from os import environ

TIME_ZONE = 'UTC'

# Set SECRET_KEY if passed in via environment variable
try:
    if environ['SECRET_KEY']:
        SECRET_KEY = environ['SECRET_KEY']
except KeyError:
    pass

CONTENT_DIR = '/opt/graphite/webapp/content'
USE_X_FORWARDED_HOST = True
