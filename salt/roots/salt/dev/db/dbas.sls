#
# salt/mysql/mysql_create_dbas.sls
#
# purpose: create the dbas for mysql
# WARNING: these users will have complete access to mysql
#          from localhost. These are used as replacement
#          for root
include:
  - db.create_dbas
  - db.dba_grants