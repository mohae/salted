#
# install percona
#
include:
  - percona.percona-server
  - percona.percona-client

python-mysqldb:
  pkg.installed
