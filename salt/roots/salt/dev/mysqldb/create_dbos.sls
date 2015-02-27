# salt/dev/mysql/create_dbos.sls
# purpose: create the dbos
# note:  the DBO, database owner, user will have complete access to
#        its respective database. DBAs, database administrators, have
#        complete access to the database server and are defined elsewhere.
#
{% for db, args in pillar['dev_mysql_dbs'].iteritems() %}
{{db}}_mysql_dbo:
  mysql_user.present:
    - name: {{args['db_user']}}
    - host: {{args['db_host']}}
    - database: "{{db}}.*"
    - password_hash: "{{args['db_pass_hash']}}"
  require:
    - {{db}}: present
    - service:
      -running: mysql
{% endfor %}
