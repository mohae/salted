qa:
  '*qa*':
    - users.users
    - users.groups
  '*qa* and G@roles:mysql-server':
    - match: compound
    - mysqldb
  '*qa* and G@roles:webserver':
    - match: compound
    - iptables
    - nginx
