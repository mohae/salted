firewall:
  install: True
  enabled: True
  strict: True
  services:
    ssh:
      block_nomatch: False
      ips_allow:
        - 192.168.0.0/24
        - 10.0.2.2/32

  ports:
    keyserver:
      port: 11371


  whitelist:
    networks:
      ips_allow:
        - 10.0.0.0/8