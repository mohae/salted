# pillar/base/redis/init.sls
include:
  - redis.checksums
  - redis.server