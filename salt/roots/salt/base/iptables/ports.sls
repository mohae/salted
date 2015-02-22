# base/iptables/port.sls
# port: define the rules for the specified ports
#
{% if salt['pillar.get']('firewall:enabled') %}
  {% set firewall = salt['pillar.get']('firewall-ports', {}) %}
  {% for port_name, port_details in firewall.get('ports', {}).items() %}  
    # Allow rules
    {% set port = port_details.get('port') %}
    {% for proto in port_details.get('proto', 'tcp') %}
      iptables_{{port_name}}_allow_{{proto}}:
        iptables.append:
          - table: filter
          - chain: INPUT
          - jump: ACCEPT
          - dport: {{ port }}
          - proto: {{ proto }}
          - save: True
    {% endfor %}
  {% endfor %}
{% endif %}