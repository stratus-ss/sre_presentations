#!/bin/bash

unshare --uts

# verify hostname
hostname
hostnamectl set-hostname tux

# observe hostname has not changed
hostname

# ssh back into the host
# observe hostname has changed on the host but not namespace
hostname

# systemd does not execute sethostname, it connects to a socket which is connected to the root namespace
# systemd relies on /run, so the solution is to mount overtop of it
#disable systemd in namespace
unshare --fork --mount --uts /bin/bash
mount -t tmpfs tmpfs /run
hostnamectl set-hostname bastion.stratus.lab

#### As container-user

unshare --map-root-user --user --mount --uts --fork /bin/bash

hostnamectl set-hostname tux 


#### as root user
lsns |grep bash

nsenter -a -t 1403
