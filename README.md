# Salt Vagrant Env

This is a very basic Salt master + two Salt minions that connect to it.

Pre-seeded keys for the minions are automatically generated during controller bootup, and accepted by the master during initialistion.
Since these are dev keys, obviously don't use them for anything.

Uses the `ubuntu/trusty` base box, for consistency and sensibility.