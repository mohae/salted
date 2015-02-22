# base/iptables/ssh-server.sls
# ssh-server: allow ssh connections from all connections
#
{% if salt['pillar.get']('firewall:enabled') %}
  {% set firewall = salt['pillar.get']('firewall-ssh-server', {}) %}
  {% set ssh_details = firewall.get('ssh') %}
  {% set port = ssh_details.get('port', 22) %}
  iptables_{{port}}_allow:
    iptables.append:
      - table: filter
      - chain: INPUT
      - jump: ACCEPT
      - dport: {{ port }}
      - proto: tcp
      - save: True
{% endif %}