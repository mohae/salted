prod-mycnf:
  file:
    - managed
    - name: /etc/mysql/my.cnf
    - source: salt://mycnf/my.cnf
    - user: mysql
    - group: mysql
    - mode: 644