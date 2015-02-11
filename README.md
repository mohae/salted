Salted
=======
**Do not use; under development**
_Currently only the `base` and `dev` environments are supported. The `nginx` role is a work in progress and `iptables` rules are not being set. There are probably some other gaps._

## Requires SaltStack 2014.7 or Greater
Both the `iptables` and `nginx` formulas that salted uses require Salt version 2014.7 (Helium) or greater. If an older version is used, errors will occur on those states.

## About
Salted is a salted deployment template that supports base, dev, qa, and production environments with web and db roles.

The salt-master and salt-minion are configured to use the same server. This is easily modified to use separate machines for the master and minion(s) by updating the `master` and `minion` files. 

The `Vagrantfile` in the root of the directory is configured to use Vagrant's salt provisioner. This makes it easy to develop and test new server deployments locally.

## Pillar Data
The pillar data contained within this repository are sample data and should not be used in deployments. Any keys contained within are publicly available and insecure!

Replace the keys with valid, secure keys. Once this is done, do not push the repository to any publicly available locations. Doing so will result in insecure servers and having critical information, including keys, exposed to the public.

## Environments
The environment is selected by matching on the minion id. If the minion's fully qualified domain name does not contain its environment as part of the name, set the minion id in the `minion` file. 

Each environment may build on what was already set in the base environment, e.g. the `dev` environment will add users and groups specific to that environment while the `base` environment adds users and groups that should exist in all environments.

### `base`
The `base` environment is used for software that should be on all machines and configurations that should be consistent across machines.

### `dev`
The 'dev' environment is for development machines.

### `qa`
The `qa` environment is for QA environments.  In the public repo, this is mostly a replication of the `dev` environment, with any dev specific stuff, like role and user, changed to qa.

### `prod`
The `prod` environment is for production environmets.  In the public repo, this is mostly a replication of the `dev` environment, with any dev specific stuff, like role and user, changed to prod.

## Roles
Roles are defined by grains. Currently there are two roles supported, `db`, for database servers, and `web`, for webservers. A machine may have more than one role.