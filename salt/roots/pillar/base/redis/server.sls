# pillar/base/redis/server.sls
redis-server:
  enabled: True
  loglevel: notice
  port: 6379
  root: /etc/redis
  var: /etc/redis
  work: /tmp/redis
  version: stable
