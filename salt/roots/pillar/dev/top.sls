dev:
  '*dev*':
    - users.users
    - users.groups
  '*dev* and G@roles:mysql-server':
    - match: compound
    - mysqldb
  '*dev* and G@roles:webserver':
    - match: compound
    - iptables
    - nginx