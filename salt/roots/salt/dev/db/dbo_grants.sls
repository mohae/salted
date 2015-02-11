#
# salt/mysql/mysql_create_dbs.sls
#
# purpose: create the db and dBOs
# note:  the DBO, database owner, user will have complete access to
#        its respective database. DBAs, database administrators, have
#        complete access to the database server and are defined elsewhere.
{% for db, args in pillar['dev_dbs'].iteritems() %}
{{db}}_dbo_grants:
  mysql_grants.present:
    - grant: {{args['db_grants']}}
    - database: "{{db}}.*"
    - user: {{args['db_user']}}
    - host: {{args['db_host']}}
  require:
    - pkg: mysql
    - {{db}}: present
{% endfor %}

