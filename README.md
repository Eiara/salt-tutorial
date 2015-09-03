# Salt Vagrant Env

This is a very basic Salt master + two Salt minions that connect to it.

Pre-seeded keys for the minions are automatically generated during controller bootup, and accepted by the master during initialistion.
Since these are dev keys, obviously don't use them for anything.

Uses `ubuntu/trusty` as the base box, and the `controller` and `test1/2` boxes on S3 are derived from that.

To pull the boxes without `vagrant up`, do:

```shell
vagrant box add controller https://s3-ap-southeast-2.amazonaws.com/salt-tutorial/controller.box
vagrant box add test1 https://s3-ap-southeast-2.amazonaws.com/salt-tutorial/test1.box
vagrant box add test2 https://s3-ap-southeast-2.amazonaws.com/salt-tutorial/test2.box
```