#!stateconf yaml . jinja

.sls_params:
  stateconf.set:
    - parent: default

# --- end of state config ---

{%- if salt['pillar.get']("%s:firewall"|format(sls_params.parent)) %}
{% set pfirewall = salt['pillar.get']("%s:firewall"|format(sls_params.parent)) %}
# Firewall management module
{%- if salt['pillar.get']('firewall:enabled') %}
  {% set firewall = salt['pillar.get']('firewall', {}) %}
  {% set install = firewall.get('install', False) %}
  {% set strict_mode = firewall.get('strict', False) %}
  {% set global_block_nomatch = firewall.get('block_nomatch', False) %}

  # Generate ipsets for all ports that we have information about
  # This does not support source specification, for that, user services
  {%- for name, port in pfirewall.get('port', {}).items() %}  
    {% set block_nomatch = service_details.get('block_nomatch', False) %}

.iptables_{{sls_params.parent}}_{{name}}_allow:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - dport: {{ port }}
    - proto: tcp
    - save: True

    {%- if not strict_mode and global_block_nomatch or block_nomatch %}
# If strict mode is disabled we may want to block anything else
.iptables_{{sls_params.parent}}_{{name}}_deny_other:
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
{%- endif %}
{%- endif %}