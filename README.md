Salted
=======
__Requires Salt version 2014.7.1 (Helium) or Greater__  
This repository uses some formulas that requires _salt 2014.7.0_.
This repository uses compound matching to match environments and roles. Compund matching was not supported in _salt 2014.7.0_ but is supported in _salt 2014.7.1_.

## About
Salted is a salted deployment template that uses both environments and roles to determine the target server's configuration. It is designed to be a template that makes it easier to build out customized server deployments with SaltStack.

The salt-master and salt-minion are configured to use the same server. This is easily modified to use separate machines for the master and minion(s) by updating the `master` and `minion` files. 

The `Vagrantfile` in the root of the directory is configured to use Vagrant's salt provisioner. This makes it easy to develop and test new server deployments locally.

## Usage:
Fork the repo and modify to suit your needs. 

For the most part, all you will need to do is modify the pillar data to meet your needs. Because the minion id is used to match environments, it will need to contain `dev`, `qa`, or `prod` as part of each minion's id; otherwise no environment, other than `base`, will be matched.

Any roles that the minion will have will also need to be added to the `minion` file as grains. Grains are specified at the end of the `minion` files in this repo.

__Once you have added private data, like server information, usernames, passwords, and keys, do not push changes to this repo to a public location, e.g. a public GitHub repo. Make sure you use a private location like GitHub's private repos or BitBucket.__ 

__Pushing such information to a public location is a serious secuirty issue. DO NOT DO IT!__

## Pillar Data
Some of the pillar data contained within this repository are sample data and should not be used in deployments. _Any keys contained within are publicly available and insecure!_

__Replace the keys with valid, secure keys. Once this is done, do not push the repository to any publicly available locations. Doing so will result in insecure servers and having critical information, including keys, exposed to the public.__

## Environments
The environment is selected by matching on the minion id. If the minion's fully qualified domain name does not contain its environment as part of the name, set the minion id in the `minion` file. 

Each environment may build on what was already set in the base environment, e.g. the `dev` environment will add users and groups specific to that environment while the `base` environment adds users and groups that should exist in all environments.

### `base`
The `base` environment is used for software that should be on all machines and configurations that should be consistent across machines. Some of the software is installed in the base environment and updated in the other environments, e.g. `nginx` and `iptables`.

### `dev`
The 'dev' environment is for development machines.

### `qa`
The `qa` environment is for QA environments.  In the public repo, this is mostly a replication of the `dev` environment, with any dev specific stuff, like role and user, changed to qa.

### `prod`
The `prod` environment is for production environments.  In the public repo, this is mostly a replication of the `dev` environment, with any dev specific stuff, like role and user, changed to prod.

## Custom Grains
Custom grains are used two help specify what should be installed where and what configuration they should use.

### Grain: roles
The `roles` grain is used to define the roles that the minion will have. Currently there are thre supported roles: `db-server`, for database servers; `db-client`, for database clients; and `webserver`, for webservers. A machine may have more than one role. A machine with the `db-server` role will usually have the `db-client` role too.

#### `mysql-server`
The percona-server role installs the Percona 5.6 database. Percona is a drop-in replacement for MySQL and the basis for MariaDB. The `my.cnf` file in this repo should be replaced with a custom `my.cnf` file whose settings have been customized to your server. A custom `my.cnf` file can be generated using [Percona's MySQL configuration wizard tool](https://tools.percona.com/wizard).

The installation of the database server is separate from the creation of the database users and databases. The database users are highly segregated to improve security of the databases and their contents. All states related to database users and databases are in the `mysqlDB` directory.

It is assumed that the database will only be accessed from localhost. Change as necessary, but it is recommended that access is only allowed from the specific private ip addresses that require access to the database servers. It is also recommended that access is not allowed from public IPs. It is better to require admins to log into a specific server and access the database servers from there using private IPs.

Databases and database users are specified per environment.

#### `mysql-client`
Install the Percona 5.6 database client.

#### `redis`
Installs Redis from source and configures it to be consistent with http://redis.io/topics/quickstart. Without a pillar, it defaults to Redis 2.8.19. With the pillar and with no modifications to it, it defaults to Redis stable.

### Grain: ssh
The `ssh` grain is used to define what kind of `ssh` access is allowed for the server. There are two rulesets defined for ssh, `ssh-server` and `ssh-restricted`. If the `ssh` grain is `server`, then the `ssh-server` rules will be applied. `ssh-restricted` is the default.

#### `server`
If the `ssh` grain is set to `server` the firewall rules used for ssh will be taken from the `pillar/base/iptables/ssh-server.sls` pillar state. This state defines the port used for ssh. The resulting firewall rule for ssh allows inbound connections from anywhere. This is useful for machines which should be accessible, via ssh, from anywhere.

#### `restricted`
This is the default rule set that is used for ssh firewall rules. The firewall rules within the `pillar/base/iptables/ssh-restricted.sls` state will be applied if the ssh grain is not set to `server`. Server access via ssh is only allowed from specified networks or IPs, typically private networks. Unless `block_nomatch` is set to `False`, all other connections will be blocked.

## Notes on specific states
This section contains additional information on states for which it may be helpful.

### Database
##### DBA
The `dba`, or database administrator has full access to all of the databases on the server. Access is only allowed from localhost. 

#### Databases and DBO
Each database has a `dbo`, or database owner. This user has full access to only the database for which it is the owner. There should be only one DBO per database. This may or may not be necessary for you. Adjust as necessary.

#### Database users
A database user has restricted access to a database: currenlty only `select`, `insert`, `update` and `delete`. This may be more permissions than you want to grant, e.g. you may wish for a user to only have `select` rights. This can be specified in the pillar.

Certain applications require more grants, like Drupal. Add only the specific grants that are required by the application. It is not recommended to do a `grant all privileges` like some guides suggest. Instead the grant list should consist of: SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, CREATE TEMPORARY TABLES.

### Firewall
The firewall is iptables. The creation of firewall rules is broken up into multiple states, with each state creating a specific type or set of firewall rules. If the server's role or environment requires additional firewall rules, the can be added. The environment specific `iptables` pillar data use compound matching to accomplish this.

#### `ufw.sls`
If the system is running Ubuntu, `ufw` will be purged from the system including `/etc/ufw`.

#### `iptables.sls`
If the firewall is enabled, this state installs the `iptables` firewall. If the system is a Debian based system, `iptables-persistent` will also be installed. It also creates the default rules including DROP INPUT, DROP FORWARD, ACCEPT OUTPUT, ACCEPT connections from localhost, and ACCEPT connections from RELATED and ESTABLISHED.

#### `ssh-server.sls`
The ssh-server state allows ssh connections from anywhere. This is useful for specifying specific machines that will accept external connections.

#### `ssh-restricted.sls`
The ssh-restricted state only allows connections from specified IPs and networks. Unless `block_nomatch` is set to `False`, everything else will be blocked. This is useful for servers on your network that will only accept connections from within your private network, or specific IPs. Ideally, these machines will not be publicly accessible.

This is the default state for ssh firewall rules.

#### `services.sls`
The services state defines the rules for services, including `block_nomatch` option and specifying specific networks or IPs. This state assumes that the service will be using the `tcp` protocol.

#### `ports.sls`
The ports state defines the rules for specific ports. There is no specification of sources, connections are accepted from anywhere. The protocol can be defined: `tcp`, `udp`, or both `tcp` and `udp`. 

#### `nat.sls`
The nat state defines the rules for NAT.

#### `whitelist.sls`
The whitelist state defines the networks or IPs that will be whitelisted. Use this state sparingly. 

## Included states:

* curl
* psmisc
* tree
* date
* git
* iptables
* local
* logrotate
* nginx
* ntp
* openssh
* percona
* redis
* sudo
* timezone
* users
* vim
* wireshark

## Pillar info:
In progress

## Errata
Please create an issue, or better yet, a pull request for any corrections or improvements that you make to this repo.