iptables-formula
================
## This is a fork of https://github.com/saltstack-formulas/iptables-formula
__Differences:__  
* `iptables/init.sls` includes the files it uses within the `iptables` directory.
* `iptables/ufw.sls` was added to purge `ufw` and the contents of `/etc/ufw` from Ubuntu based systems
* `iptables/iptables.sls` was added. 
  * The functionality that was within the original formula's `init.sls` was moved to this file
  * The default behavior for the `FORWARD` chain is to `DROP`.
  * A _port_ processing section was added for adding ports without sources.
    * Allows for multiple protocols, specified as a list.
    * Default protocol is `TCP`
* pillar.example was updated to add an example for the new `ports` specification.

### Note
I did not include the `iptables/services.sls` stated in `init.sls` because it did not appear to be used. I'm probably wrong. Please let me know what I am missing in regards to that file

This module manages your firewall using iptables with pillar configured rules. 
Thanks to the nature of Pillars it is possible to write global and local settings (e.g. enable globally, configure locally)

Pull requests are welcome for other platforms (or other improvements ofcourse!)

Usage
=====

All the configuration for the firewall is done via pillar (pillar.example).

Enable globally:
`pillars/firewall.sls`
```
firewall:
  enabled: True
  install: True  
  strict: True
```

Allow SSH:
`pillars/firewall/ssh.sls`
```
firewall:
  services:
    ssh:
      block_nomatch: False
      ips_allow:
        - 192.168.0.0/24
        - 10.0.2.2/32
```

Allow an entire class such as your internal network:

```
  whitelist:
    networks:
      ips_allow:
        - 10.0.0.0/8
```

Salt combines both and effectively enables your firewall and applies the rules.

Notes:
 * Setting install to True will install `iptables` and `iptables-perrsistent` for you
 * Strict mode means: Deny **everything** except explicitly allowed (use with care!)
 * block_nomatch: With non-strict mode adds in a "REJECT" rule below the accept rules, otherwise other traffic to that service is still allowed. Can be defined per-service or globally, defaults to False.
 * Servicenames can be either port numbers or servicenames (e.g. ssh, zabbix-agent, http) and are available for viewing/configuring in `/etc/services`

Using iptables.service
======================

Salt can't merge pillars, so you can only define `firewall:services` in once place. With the firewall.service state and stateconf, you can define pillars for different services and include and extend the iptables.service state with the `parent` parameter to enable a default firewall configuration with special rules for different services.

`pillars/otherservice.sls`
```
otherservice:
  firewall:
    services:
      http:
        block_nomatch: False
        ips_allow:
          - 0.0.0.0/0
```

`states/otherservice.sls`
```
#!stateconf yaml . jinja

include:
  - iptables.service

extend:
  iptables.service::sls_params:
    stateconf.set:
      - parent: otherservice
```

Using iptables.nat
==================

You can use nat for interface.

```
#!stateconf yaml . jinja

# iptables -t nat -A POSTROUTING -o eth0 -s 192.168.18.0/24 -j MASQUERADE

  nat:
    eth0:
      ips_allow:
        - 192.168.18.0/24
```
