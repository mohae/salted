prod:
  '*prod*':
    - users.users
    - users.groups
  '*prod* and G@roles:mysql-server':
    - match: compound
    - mysqldb
  '*prod* and G@rolse:webserver':
    - match: compound
    - iptables
    - nginx