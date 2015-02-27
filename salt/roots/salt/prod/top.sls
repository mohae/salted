prod:
  '*prod*':
    - users
  '*prod* and G@roles:mysql-server':
    - match: compound
    - mycnf
    - mysqldb
    
