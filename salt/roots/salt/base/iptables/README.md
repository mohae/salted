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
* `proto` has been added to services to allow for specification of protocols of a service.
* the `iptables/service.sls` has been removed as this file is superfluous and adds unnecessary complexity. Pillars are flattened and merged so as long as the `id` is different, additional declarations can be added in other files as needed.

### Note
This module manages your firewall using iptables with pillar configured rules. 
Thanks to the nature of Pillars it is possible to write global settings along with environment, role, or any glob based matching to specify additonal firewall rules.

Usage
=====

All the configuration for the firewall is done via pillar (pillar.example). Each file in addition to `firewall.sls` 

Specify the state files to include:    
`pillars/firewall/init.sls`  
```
include:  
  - .firewall  
  - .ssh  
  - .dns  
```
Enable globally: 
`pillars/firewall/firewall.sls`  
```
firewall:  
  enabled: True  
  install: True    
  strict: True  
```

Allow SSH:  
`pillars/firewall/ssh.sls`
```
ssh-firewall:
  services:
    ssh:
      block_nomatch: False
      proto:
        - tcp
      ips_allow:
        - 192.168.0.0/24
        - 10.0.2.2/32
```

Allow dns port:  
`pillars/firewall/dbs.sls`
```
ks-firewall:
  ports:
    dns:
      port: 53
      proto:
        - tcp
        - udp
```

Allow an entire class such as your internal network:  

```
  whitelist:
    networks:
      ips_allow:
        - 10.0.0.0/8
```

Salt combines both and effectively enables your firewall and applies the rules.

See `pillar.example` for a complete example.

Notes:
 * Setting install to True will install `iptables` and `iptables-persistent` for you
 * Strict mode means: Deny **everything** except explicitly allowed (use with care!)
 * block_nomatch: With non-strict mode adds in a "REJECT" rule below the accept rules, otherwise other traffic to that service is still allowed. Can be defined per-service or globally, defaults to False.
 * Servicenames can be either port numbers or servicenames (e.g. ssh, zabbix-agent, http) and are available for viewing/configuring in `/etc/services`.


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
