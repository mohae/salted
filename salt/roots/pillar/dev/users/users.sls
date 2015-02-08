#
# pillar/users.sls
#
users:
  devuser:
    fullname: dev user
    password: $6$M8D12WUh$5kqIW1R6SWvG9mFEWSLWhnQCR6vZWXwsisj.t6ZwInaEDKmD/j8NgG4y60EJk7HKBRPkwD3lOTSJo6dzxHaf./
    email: devuser@example.com
    shell: /bin/bash
    home: /home/devwuser
    createhome: True
    uid: 3001
    gid: 3001
    groups:
      - sudo
      - dev
    ssh_key_type: rsa
    ssh_keys:
        pubkey: id_rsa.pub
    ssh_auth:
      - id_rsa.pub
    enforce_password: True
    key.pub: True
    user.ssh_key: ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key
