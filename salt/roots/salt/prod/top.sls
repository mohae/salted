prod:
  '*prod*':
    - users
  '*prod* and G@roles:db':
    - match: compound
    - mycnf
    - db
    
