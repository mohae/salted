﻿qa:
  '*':
    - users.users
    - users.groups
  'roles:db':
    - match: grain
    - db.dbas
    - db.dbs
    - db.db_users
  'roles:web':
    - match: grain
    - nginx