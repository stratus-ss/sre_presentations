#!/bin/bash

#### as container-user on host
sleep 99999 &

#### create namespace as container-user
PS1='\u@PID # ' unshare --fork --user --map-root-user --pid /bin/bash
ps aux |grep sleep

kill -9 976

sleep 77777 &

# demonstrate that all pids are visible from the current PID namespace
ps -ef


### On the host

lsns |grep bash

       NS TYPE   NPROCS    PID USER             COMMAND
4026532952 pid         4 11634 root             /bin/bash
4026532954 pid         4 11655 root             /bin/bash


# take the pid and look at NSPID

sudo cat /proc/11655/status |grep NSpid
NSpid:	11655	6	1

# nsenter into the NS and see the pid


##### From another shell
ps aux |grep sleep


# Exit the container and create one with the mount namespace
PS1='\u@PID$ ' unshare --fork --user --map-root-user --pid --mount /bin/bash

ps aux
mount -t proc proc /proc

#alternative way use –mount-proc
PS1='\u@PID$ ' unshare --fork --user --map-root-user --pid --mount-proc /bin/bash
