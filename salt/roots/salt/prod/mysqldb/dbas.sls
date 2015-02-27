# salt/prod/mysqldb/dbas.sls
# purpose: create the dbas for mysql
# WARNING: these users will have complete access to mysql
#          from localhost. These are used as replacement
#          for root
#
include:
  - mysqldb.create_dbas
  - mysqldb.dba_grants