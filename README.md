Graphite
===

This is a modified version of [BNOTIONS/graphite](https://github.com/BNOTIONS/dockerfiles/tree/master/graphite) that installs the latest version (0.10 prerelease) of graphite from git rather than 0.9.X from pip.

That was a modified version of [nickstenning/graphite](https://github.com/nickstenning/dockerfiles/tree/master/graphite) that works with the latest version of docker (0.8.1) and supports setting the django SECRET_KEY via environment variable.


Ports
---

* `80` - nginx proxy to graphite
* `2003` - carbon-cache line receiver
* `2004` - carbon-cache pickle receiver
* `7002` - carbon-cache query port


Volumes
---

* `/opt/graphite/storage/whisper` - Whisper data file directory

	It is recommended that you keep your whisper data files stored on your host system outside of the docker container.

Building
---

* Default docker build example:

	`docker build -rm -t bryanlarsen/graphite .`


Running
---

* Default docker run example:

	`docker run -d bryanlarsen/graphite`

* Publish all ports from container (docker will handle port mapping)

	`docker run -P -e SECRET_KEY='random-secret-key' -d bryanlarsen/graphite`

* Publish all ports from container to host (manual port mapping)

	`docker run -p 80:80 -p 2003:2003 -p 2004:2004 -p 7002:7002 -e SECRET_KEY='random-secret-key' -d bryanlarsen/graphite`

* Mount data volume from host for whisper data storage

	`docker run -v /data/graphite:/opt/graphite/storage/whisper -e SECRET_KEY='random-secret-key' -d bryanlarsen/graphite`

* Publish all ports to host and mount data volume from host

	`docker run -p 80:80 -p 2003:2003 -p 2004:2004 -p 7002:7002 -v /data/graphite:/opt/graphite/storage/whisper -e SECRET_KEY='random-secret-key' -d bryanlarsen/graphite`


Important
---

A superuser account is created with username admin, password admin.  Change it by visiting http://localhost/admin/password_change/
