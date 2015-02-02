# vagrant elasticsearch cluster

This vagrant package lets you easily deploy an [elasticsearch](http://elasticsearch.org)
cluster of any size.

This vagrant file has full compatibility with exoscale.

## Requirements

- A working [vagrant](http://vagrantup.com) installation
- The vagrant hostmanager plugin, install it with `vagrant plugin install hostmanager` (known working version: 0.6.0)
- The vagrant cloudstack plugin, install it with `vagrant plugin install cloudstack` (known working version 1.4.0)

## Configuration variables:

This vagrantfile can be configured with the following environment variables:

*Required variables*

- `EXOSCALE_API_KEY`: required exoscale api key
- `EXOSCALE_API_SECRET`: required exoscale api secret

*Optional variables*

- `CLUSTER_SIZE`: size of the elasticsearch cluster you want to build, defaults to `3`
- `CLUSTER_NAME`: the name of your cluster, defaults to `search_cluster`
- `EXOSCALE_TEMPLATE`: template to use, defaults to a 50GB ubuntu 14.04
- `EXOSCALE_KEYPAIR`: defaults to `default`
- `EXOSCALE_INSTANCE_TYPE`: default to a medium (4GB, 2CPU) instance

## Creating the cluster

Just start vagrant with the following command:

```
vagrant up --provider=cloudstack
```



