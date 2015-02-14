#
# salt/percona.sls
# install Percona from .deb
# supported OS: Debian Squeeze
#               Debiab Wheezy
#               Ubuntu Precise
#               Ubuntu Trusty
#
# Only lts versions are supported for debian

{% if grains['os'] == 'Ubuntu' %}
{% if grains['oscodename'] == 'precise' %}
{% set repo_name = 'deb http://repo.percona.com/apt precise main' %}
{% else %}
{% set repo_name = 'deb http://repo.percona.com/apt trusty main' %}
{% endif %}
{% elif grains['os'] == 'Debian' %}
include:
  - python-apt
  - apt
{% if grains['oscodename'] == 'squeeze' %}
{% set repo_name = 'deb http://repo.percona.com/apt squeeze main' %}
{% else %}
{% set repo_name = 'deb http://repo.percona.com/apt wheezy main' %}
{% endif %}
{% endif %}
percona-pkrepo:
  pkgrepo.managed:
    - name: {{repo_name}}
    - disabled: False
    - keyid: 1C4CBDCDCD2EFD2A
    - keyserver: keys.gnupg.net
{% if grains['os'] == 'Debian' %}
    - require:
    - pkg: python-apt
{% endif %}