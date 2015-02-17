# Firewall management module
{%- if salt['pillar.get']('firewall:enabled') %}
  {% set firewall = salt['pillar.get']('firewall', {}) %}
  {% set install = firewall.get('install', False) %}
  {% set strict_mode = firewall.get('strict', False) %}
  {% set global_block_nomatch = firewall.get('block_nomatch', False) %}
  {% set packages = salt['grains.filter_by']({
    'Debian': ['iptables', 'iptables-persistent'],
    'RedHat': ['iptables'],
    'default': 'Debian'}) %}

      {%- if install %}
      # Install required packages for firewalling      
      iptables_packages:
        pkg.installed:
          - pkgs:
            {%- for pkg in packages %}
            - {{pkg}}
            {%- endfor %}
      {%- endif %}

    {%- if strict_mode %}
      # Set the policy to deny everything unless defined          
      enable_input_reject_policy:
        iptables.set_policy:
          - table: filter
          - chain: INPUT
          - policy: DROP
          - require:
            - iptables: iptables_allow_localhost
            - iptables: iptables_allow_established

      enable_forward_reject_policy:
        iptables.set_policy:
          - table: filter
          - chain: FORWARD
          - policy: DROP

      # If the firewall is set to strict mode, we'll need to allow some 
      # that always need access to anything
      iptables_allow_localhost:
        iptables.append:
          - table: filter
          - chain: INPUT
          - jump: ACCEPT
          - source: 127.0.0.1
          - save: True

      # Allow related/established sessions
      iptables_allow_established:
        iptables.append:
          - table: filter
          - chain: INPUT
          - jump: ACCEPT
          - match: conntrack
          - ctstate: 'RELATED,ESTABLISHED'
          - save: True                
    {%- endif %}

  # Generate ipsets for all services that we have information about
  {%- for service_name, service_details in firewall.get('services', {}).items() %}  
    {% set block_nomatch = service_details.get('block_nomatch', False) %}

    # Allow rules for ips/subnets
    {%- for ip in service_details.get('ips_allow',{}) %}
      iptables_{{service_name}}_allow_{{ip}}:
        iptables.append:
          - table: filter
          - chain: INPUT
          - jump: ACCEPT
          - source: {{ ip }}
          - dport: {{ service_name }}
          - proto: tcp
          - save: True
    {%- endfor %}


    {%- if not strict_mode and global_block_nomatch or block_nomatch %}
      # If strict mode is disabled we may want to block anything else
      iptables_{{service_name}}_deny_other:
        iptables.append:
          - position: last
          - table: filter
          - chain: INPUT
          - jump: REJECT
          - dport: {{ service_name }}
          - proto: tcp
          - save: True
    {%- endif %}    

  {%- endfor %}

  # Generate ipsets for all ports that we have information about
  {%- for port_name, port_details in firewall.get('ports', {}).items() %}  
    {% set block_nomatch = port_details.get('block_nomatch', False) %}

    # Allow rules
    {% set port = port_details.get('port') %}
      iptables_{{port_name}}_allow:
        iptables.append:
          - table: filter
          - chain: INPUT
          - jump: ACCEPT
          - dport: {{ port }}
          - proto: tcp
          - save: True

    {%- if not strict_mode and global_block_nomatch or block_nomatch %}
      # If strict mode is disabled we may want to block anything else
      iptables_{{port_name}}_deny_other:
        iptables.append:
          - position: last
          - table: filter
          - chain: INPUT
          - jump: REJECT
          - dport: {{ port }}
          - proto: tcp
          - save: True
    {%- endif %}    
  {%- endfor %}


  # Generate ipsets for all ports that we have information about
  {%- for port_name, port_details in firewall.get('env-ports', {}).items() %}  
    {% set block_nomatch = port_details.get('block_nomatch', False) %}

    # Allow rules
    {% set port = port_details.get('port') %}
      iptables_{{port_name}}_allow:
        iptables.append:
          - table: filter
          - chain: INPUT
          - jump: ACCEPT
          - dport: {{ port }}
          - proto: tcp
          - save: True

    {%- if not strict_mode and global_block_nomatch or block_nomatch %}
      # If strict mode is disabled we may want to block anything else
      iptables_{{port_name}}_deny_other:
        iptables.append:
          - position: last
          - table: filter
          - chain: INPUT
          - jump: REJECT
          - dport: {{ port }}
          - proto: tcp
          - save: True
    {%- endif %}    
  {%- endfor %}
  
  # Generate rules for NAT
  {%- for service_name, service_details in firewall.get('nat', {}).items() %}  
    {%- for ip_s, ip_d in service_details.get('rules', {}).items() %}
      iptables_{{service_name}}_allow_{{ip_s}}_{{ip_d}}:
        iptables.append:
          - table: nat 
          - chain: POSTROUTING 
          - jump: MASQUERADE
          - o: {{ service_name }} 
          - source: {{ ip_s }}
          - destination: {{ip_d}}
          - save: True
    {%- endfor %}
  {%- endfor %}

  # Generate rules for whitelisting IP classes
  {%- for service_name, service_details in firewall.get('whitelist', {}).items() %}
    {%- for ip in service_details.get('ips_allow',{}) %}
      iptables_{{service_name}}_allow_{{ip}}:
        iptables.append:
           - table: filter
           - chain: INPUT
           - jump: ACCEPT
           - source: {{ ip }}
           - save: True
    {%- endfor %}
  {%- endfor %}

{%- endif %}