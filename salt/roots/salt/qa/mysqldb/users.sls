# salt/qa/mysqldb/users.sls
include:
  - mysqldb.create_users
  - mysqldb.user_grants