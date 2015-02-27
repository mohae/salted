# salt/qa/user_grants.sls
# purpose: create the users and databases for apps using mysql
#
{% for user, args in pillar['qa_mysql_db_users'].iteritems() %}
{{user}}_mysql_dbuser_grants:
  mysql_grants.present:
    - grant: {{args['db_grants']}}
    - database: "{{args['database']}}.*"
    - user: {{user}}
    - host: {{args['db_host']}}
  require:
    - pkg: percona-server
    - {{args['database']}}: present
{% endfor %}

