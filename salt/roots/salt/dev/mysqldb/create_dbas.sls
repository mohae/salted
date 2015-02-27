# salt/dev/mysqldb/create_dbas.sls
# purpose: create the dbas for mysql
# WARNING: these users will have complete access to mysql
#          from localhost. These are used as replacement
#          for root
#
{% for dba, args in pillar['dev_mysql_dbas'].iteritems() %}
{{dba}}_mysql_create_dba:
  mysql_user.present:
    - name: {{dba}}
    - host: {{args['db_host']}}
    - password_hash: "{{args['db_pass_hash']}}"
  require:
    - pkg: percona-server
{% endfor %}

