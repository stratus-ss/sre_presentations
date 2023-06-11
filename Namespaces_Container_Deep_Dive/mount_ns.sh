#!/bin/bash

# Create the namespace and explore:
PS1='\u@new-mnt$ ' unshare --user --mount --map-root-user

df -h
ls /

# Inside the namespace create tmpfs

root@new-mnt$ mount -t tmpfs tmpfs /mnt
findmnt |grep mnt
└─/mnt     tmpfs               tmpfs      rw,relatime,seclabel,uid=1000,gid=1000

# outside the namespace
[root@rhel8-demo ~]# findmnt |grep mnt


