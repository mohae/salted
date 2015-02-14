percona-client:
  pkg:
    - installed
    - name: percona-server-client-5.6
    - require:
      - pkg: percona-server-server-5.6

