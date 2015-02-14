#
# salt/mysql/mysql_create_dbs.sls
#
# purpose: create the db and dBOs
# note:  the DBO, database owner, user will have complete access to
#        its respective database. DBAs, database administrators, have
#        complete access to the database server and are defined elsewhere.
{% for db, args in pillar['prod_dbs'].iteritems() %}
{{db}}_prod_dbo:
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
