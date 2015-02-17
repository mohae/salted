Salted
=======
__Requires Salt version 2014.7.1 (Helium) or Greater__  
This repository uses some formulas that requires _salt 2014.7.0_.
This repository uses compound matching to match environments and roles. This was not supported in _salt 2014.7.0_ but is supported in _salt 2014.7.1_.

## About
Salted is a salted deployment template that supports base, dev, qa, and production environments with web and db roles. It is designed to be a template that makes it easier to build out customized server deployments with SaltStack.

The salt-master and salt-minion are configured to use the same server. This is easily modified to use separate machines for the master and minion(s) by updating the `master` and `minion` files. 

The `Vagrantfile` in the root of the directory is configured to use Vagrant's salt provisioner. This makes it easy to develop and test new server deployments locally.

## Usage:
Fork the repo and modify to suit your needs. 

For the most part, all you will need to do is modify the pillar data to meet your needs. Because the minion id is used to match environments, it will need to contain `dev`, `qa`, or `prod` as part of each minion's id; otherwise no environment, other than `base`, will be matched.

Any roles that the minion will have will also need to be added to the `minion` file as grains. Grains are specified at the end of the `minion` files in this repo.

Once you have added private data, like server information, usernames, passwords, and keys, do not push changes to this repo to a public location, e.g. a public GitHub repo. Make sure you use a private location like GitHub's private repos or BitBucket. 

Pushing such information to a public location is a serious secuirty issue. DO NOT DO IT!

## Pillars, Environments, Roles, and States
### Pillar Data
Some of the pillar data contained within this repository are sample data and should not be used in deployments. Any keys contained within are publicly available and insecure!

Replace the keys with valid, secure keys. Once this is done, do not push the repository to any publicly available locations. Doing so will result in insecure servers and having critical information, including keys, exposed to the public.

### Environments
The environment is selected by matching on the minion id. If the minion's fully qualified domain name does not contain its environment as part of the name, set the minion id in the `minion` file. 

Each environment may build on what was already set in the base environment, e.g. the `dev` environment will add users and groups specific to that environment while the `base` environment adds users and groups that should exist in all environments.

#### `base`
The `base` environment is used for software that should be on all machines and configurations that should be consistent across machines.

#### `dev`
The 'dev' environment is for development machines.

#### `qa`
The `qa` environment is for QA environments.  In the public repo, this is mostly a replication of the `dev` environment, with any dev specific stuff, like role and user, changed to qa.

#### `prod`
The `prod` environment is for production environmets.  In the public repo, this is mostly a replication of the `dev` environment, with any dev specific stuff, like role and user, changed to prod.

### Roles
Roles are defined by grains. Currently there are two roles supported, `db`, for database servers, and `web`, for webservers. A machine may have more than one role.

#### `db`
PerconaDB is the database. Percona is a drop-in replacement for MySQL and the basis for MariaDB. The `my.cnf` file in this repo should be replaced with a custom `my.cnf` file whose settings have been customized to your server. A custom `my.cnf` file can be generated using [Percona's MySQL configuration wizard tool](https://tools.percona.com/wizard).

#### `webserver`
The webserver is `nginx`, which is an event driven webserver and is better suited for modern web workloads, e.g. mobile, than the threaded Apache. Apache does have an event driven version, but, sometimes, a swiss army knife is not needed. If your needs are better suited for Apache, well, I might add support for Apache too, some day.

The webserver role also adds `iptables` rules for allowing incoming tcp connections on port 80 and 443.

## Notes:
`iptables` is used for the firewall. If you are running Ubuntu, `ufw` will be purged from the system.

## Errata
Please create an issue, or better yet, a pull request for any corrections or improvements that you make to this repo.