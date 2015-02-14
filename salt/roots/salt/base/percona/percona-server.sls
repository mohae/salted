percona-server:
  pkg:
    - installed
    - name: percona-server-server-5.6
  service:
    - running
    - name: mysql
    - enable: True
    - watch:
      - pkg: percona-server-server-5.6
      - file: /etc/mysql/my.cnf

/etc/mysql/my.cnf:
  file:
    - managed
    - name: /etc/mysql/my.cnf
    - source: salt://percona/my.cnf
    - user: mysql
    - group: mysql
    - mode: 644

date > /tmp/started_mysql:
  cmd.wait:
    - watch:
      - service: mysql

#sed -i 's/run/lib/g' /etc/mysql/debian.cnf:
#  cmd.wait:
#    - watch:
#      - pkg: percona-server-server-5.6

#sed -i 's/mysqld/mysql/g' /etc/mysql/debian.cnf:
#  cmd.wait:
#    - watch:
#      - pkg: percona-server-server-5.6
