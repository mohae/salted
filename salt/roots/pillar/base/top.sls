# pillar/base/top.sls
base:
  '*':
    - iptables
    - users.users
    - users.groups