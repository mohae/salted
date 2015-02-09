# pillar/base/top.sls
base:
  '*':
    - users.users
    - users.groups