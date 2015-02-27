qa:
  '*qa*':
    - users
  '*qa* and G@roles:mysql-server':
    - match: compound
    - mycnf
    - mysqldb
