# pillar/base/top.sls
base:
  '*':
    - iptables
    - users
