#
# salt/mysql_create_users.sls
#
# purpose: create the users and databases for apps using mysql
{% for user, args in pillar['prod_db_users'].iteritems() %}
{{user}}_prod_db_user:
  mysql_user.present:
    - name: {{user}}
    - host: {{args['db_host']}}
    - password_hash: "{{args['db_pass_hash']}}"
  require:
    - pkg: percona-server
    - {{args['database']}}: present
{% endfor %}
