dev:
  '*dev*':
    - wireshark
    - users
  '*dev* and G@roles:db':
    - match: compound
    - mycnf
    - db
    
