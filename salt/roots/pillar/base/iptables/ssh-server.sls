 # pillar/base/iptables/ssh-server.sls
 # ssh-server accepts connections from anywhere
 firewall-ssh-server:
    ssh:
      port: 22
