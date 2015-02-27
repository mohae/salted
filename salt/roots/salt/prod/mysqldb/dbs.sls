# salt/prod/mysqldb/dbs.sls
# purpose: create the dbs and dbos for mysql
#
include:
  - mysqldb.create_dbs
  - mysqldb.create_dbos
  - mysqldb.dbo_grants