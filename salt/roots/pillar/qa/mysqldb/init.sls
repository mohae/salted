﻿# pillar/qa/mysqldb/init.sls

include:
  - mysqldb.db_users
  - mysqldb.dbas
  - mysqldb.dbs