dev:
  '*dev*':
    - users.users
    - users.groups
  '*dev* and G@roles:db':
    - match: compound
    - db.dbas
    - db.dbs
    - db.db_users
  '*dev* and G@roles:webserver':
    - match: compound
    - iptables
    - nginx