## salty-web/top.sls
## 
## Supported environments:
##   base: stuff common to all environments
##   webserver: for installation and configuration of a webserver
##   database: for installation and configuration of database
##
##   set base tree state: calls base.sls for most of the work

base:
  '*':
    - curl
    - date
    - git
#    - hosts
    - iptables
    - locale
    - logrotate
    - ntp
    - openssh
    - psmisc
    - sudo
    - timezone
    - tree
    - users
    - vim
