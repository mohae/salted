#
# install percona
#
include:
  {% if "mysql-server" in grains.get('roles', []) %}
    - percona.percona-server
  {% endif %}
  {% if "mysql-client" in grains.get('roles', []) %}
    - percona.percona-client
  {% endif %}

python-mysqldb:
  pkg.installed
