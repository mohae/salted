prod:
  '*prod*':
    - users.users
    - users.groups
  '*prod* and G@roles:db':
    - match: compound
    - db.dbas
    - db.dbs
    - db.db_users