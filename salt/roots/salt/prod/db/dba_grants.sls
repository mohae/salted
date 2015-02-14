#
# salt/mysql/mysql_dba_grants.sls
#
# purpose: grant all permissions to database admins, dba or dbo
# WARNING: these users will have complete access to mysql
#          from localhost. These are used as replacement
#          for root
{% for dba, args in pillar['prod_dbas'].iteritems() %}
{{dba}}_prod_dba_grants:
  mysql_grants.present:
    - grant: all privileges
    - database: "*.*"
    - user: {{dba}}
    - host: {{args['db_host']}}
    - require:
      - pkg: percona-server
{% endfor %}

