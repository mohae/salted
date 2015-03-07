# redis/init.sls
# Installs redis based on the pillar settings.

{% if salt['pillar.get']('redis-server:enabled', 'enabled') %}
{% set version = salt['pillar.get']('redis-server:version', '2.8.19') %}
{% set checksum_info = salt['pillar.get']('redis-checksums:redis-' + version + '-checksum', {}) %}
{% set algo = checksum_info.get('algo', 'sha1') %}
{% set checksum = checksum_info.get('checksum', '3e362f4770ac2fdbdce58a5aa951c1967e0facc8') %}
{% set loglevel = salt['pillar.get']('redis-server:loglevel', 'notice') %}
{% set port = salt['pillar.get']('redis-server:port', 6379) %}
{% set root = salt['pillar.get']('redis-server:root', '/etc/redis') %}
{% set var = salt['pillar.get']('redis-server:var', '/var/redis') %}
{% set work = salt['pillar.get']('redis-server:work', '/tmp/redis') %}

redis-{{ version }}-dependencies:
  pkg.installed:
    - names:
    {% if grains['os_family'] == 'Debian' %}
      - build-essential
      - libxml2-dev
      - python-dev
    {% elif grains['os_family'] == 'RedHat' %}
      - make
      - libxml2-dev
      - python-devel
    {% endif %}

download-redis-{{ version }}:
  archive.extracted:
    - name: {{ work }}
    {% if version == 'stable' %}
    - source: http://download.redis.io/redis-stable.tar.gz
    {% else %}
    - source: http://download.redis.io/releases/redis-{{ version }}.tar.gz
    {% endif %}
    - source_hash: {{ algo }}={{ checksum }}
    - archive_format: tar
    - if_missing: {{ work }}/redis-{{ version }}
    - require:
      - pkg: redis-{{ version }}-dependencies

make-redis-{{ version }}:
  cmd.wait:
    - watch:
      - archive: download-redis-{{ version }}
    - cwd: {{ work }}/redis-{{ version }}
    - names:
      - make

redis-{{ version }}-executables:
  cmd.wait:
    - watch:
      - cmd: make-redis-{{ version }}
    - cwd: {{ work }}/redis-{{ version }}/src
    - names:
      - cp redis-server /usr/local/bin/
      - cp redis-cli /usr/local/bin/
      - cp redis-server /usr/local/bin/
      - cp redis-sentinel /usr/local/bin/
      - cp redis-benchmark /usr/local/bin/
      - cp redis-check-aof /usr/local/bin/
      - cp redis-check-dump /usr/local/bin/
      

redis-{{ version }}-copy-init:
  cmd.wait:
    - cwd: {{ work }}/redis-{{ version }}
    - names:
      - cp utils/redis_init_script /etc/init.d/redis_{{ port }}
    - watch:
      - cmd: make-redis-{{ version }}

config-redis-{{ version }}-dirs:
  cmd.wait:
    - names:
      - mkdir {{ root }}
      - mkdir {{ var }}
    - watch:
      - cmd: redis-{{ version }}-executables

setup-redis-{{ version }}:
  cmd.wait:
    - cwd: {{ work }}/redis-{{ version }}
    - names:
      - mkdir {{ var }}/{{ port }}
      - cp redis.conf {{ root }}/{{ port }}.conf
      - update-rc.d redis_{{ port }} defaults
    - watch:
      - cmd: config-redis-{{ version }}-dirs

redis-{{ version }}-config-daemonize:
  file.replace:
    - name: {{ root }}/{{ port }}.conf
    - pattern: "daemonize no"
    - repl: "daemonize yes"
    - require:
      - cmd: redis-{{ version }}-executables

redis-{{ version }}-config-pidfile:
  file.replace:
    - name: {{ root }}/{{ port }}.conf
    - pattern: "pidfile /var/run/redis.pid"
    - repl: "pidfile /var/run/redis_{{ port }}.pid"
    - require:
      - cmd: redis-{{ version }}-executables

redis-{{ version }}-config-port:
  file.replace:
    - name: {{ root }}/{{ port }}.conf
    - pattern: "port 6379"
    - repl: "port {{ port }}"
    - require:
      - cmd: redis-{{ version }}-executables

redis-{{ version }}-config-loglevel:
  file.replace:
    - name: {{ root }}/{{ port }}.conf
    - pattern: "loglevel notice"
    - repl: "loglevel {{ loglevel }}"
    - require:
      - cmd: redis-{{ version }}-executables

redis-{{ version }}-config-logfile:
  file.replace:
    - name: {{ root }}/{{ port }}.conf
    - pattern: "logfile \"\""
    - repl: "logfile \"/var/log/redis_{{ port }}.log\""
    - require:
      - cmd: redis-{{ version }}-executables

redis-{{ version }}-config-dir:
  file.replace:
    - name: {{ root }}/{{ port }}.conf
    - pattern: "dir ./"
    - repl: "dir {{ var }}/{{ port }}"
    - require:
      - cmd: redis-{{ version }}-executables

redis_{{ port }}:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - cmd: redis-{{ version }}-executables

{% endif %}  