#
# install percona
#
include:
  {% if "db-server" in grains.get('roles', []) %}
    - percona.percona-server
  {% endif %}
  {% if "db-client" in grains.get('roles', []) %}
    - percona.percona-client
  {% endif %}

python-mysqldb:
  pkg.installed
