# pillar/base/iptables/nat.sls
# nat: define nat rules
firewall-nat:
  nat:
    eth0:
      rules:
        '192.168.18.0/24':
          '10.20.0.2'
