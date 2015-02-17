qa:
  '*qa*':
    - users.users
    - users.groups
  '*qa* and G@roles:db':
    - match: compound
    - db.dbas
    - db.dbs
    - db.db_users
  '*qa* and G@roles:webserver':
    - match: compound
    - iptables
    - nginx
