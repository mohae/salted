dev:
  '*dev*':
    - wireshark
    - users
  '*dev* and G@roles:mysql-server':
    - match: compound
    - mycnf
    - mysqldb
    
