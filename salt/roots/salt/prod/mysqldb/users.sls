# salt/prod/mysqldb/users.sls
include:
  - mysqldb.create_users
  - mysqldb.user_grants