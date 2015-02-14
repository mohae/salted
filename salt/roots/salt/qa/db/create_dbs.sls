#
# salt/mysql/mysql_create_dbs.sls
#
# purpose: create the db and dBOs
# note:  the DBO, database owner, user will have complete access to
#        its respective database. DBAs, database administrators, have
#        complete access to the database server and are defined elsewhere.
{% for db, args in pillar['qa_dbs'].iteritems() %}
{{db}}_db:
  mysql_database.present:
    - name: {{args['db_name']}}
  require:
    - service.running: mysql
{% endfor %}
