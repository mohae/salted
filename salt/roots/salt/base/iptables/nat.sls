# base/iptables/port.sls
# port: define the rules for the specified ports
#
{% if salt['pillar.get']('firewall:enabled') %}
  {% set firewall = salt['pillar.get']('firewall-nat', {}) %}
  {% for network_interface, nat_details in firewall.get('nat', {}).items() %}  
    {% for ip_s, ip_d in nat_details.get('rules', {}).items() %}
      iptables_{{network_interface}}_allow_{{ip_s}}_{{ip_d}}:
        iptables.append:
          - table: nat 
          - chain: POSTROUTING 
          - jump: MASQUERADE
          - o: {{ network_interface }} 
          - source: {{ ip_s }}
          - destination: {{ ip_d }}
          - save: True
    {% endfor %}
  {% endfor %}
{% endif %}