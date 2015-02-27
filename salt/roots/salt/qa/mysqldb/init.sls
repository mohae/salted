# salt/qa/mysqldb/init.sls
include:
  - mysqldb.dbas
  - mysqldb.dbs
  - mysqldb.users