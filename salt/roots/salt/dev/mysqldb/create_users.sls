# salt/dev/mysql/create_users.sls
# purpose: create the users for mysql
#
{% for user, args in pillar['dev_mysql_db_users'].iteritems() %}
{{user}}_mysql_db_user:
  mysql_user.present:
    - name: {{user}}
    - host: {{args['db_host']}}
    - password_hash: "{{args['db_pass_hash']}}"
  require:
    - pkg: percona-server
    - {{args['database']}}: present
{% endfor %}
