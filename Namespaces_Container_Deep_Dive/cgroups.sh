#!/bin/bash

mkdir -p /my_cgroups/{memory,cpusets,cpu}
mount -t cgroup -o memory none /my_cgroups/memory
mount -t cgroup -o cpu,cpuacct none /my_cgroups/cpu
mount -t cgroup -o cpuset none /my_cgroups/cpusets

mkdir -p /my_cgroups/cpu/{user1,user2,user3}

#  Set the number of CPU shares
echo 2048 > /my_cgroups/cpu/user1/cpu.shares
echo 1024 > /my_cgroups/cpu/user2/cpu.shares
echo 1024 > /my_cgroups/cpu/user3/cpu.shares
#echo 768 > /my_cgroups/cpu/user2/cpu.shares
#echo 512 > /my_cgroups/cpu/user3/cpu.shares

# generate some load
cat /dev/urandom > /dev/null

# note the pids
ps aux |grep sha256sum

# add pids to /my_cgroups/cpu/user{1,2,3}
echo 1570 > /my_cgroups/cpu/user1/tasks
echo 1571 > /my_cgroups/cpu/user2/tasks
echo 1572 > /my_cgroups/cpu/user3/tasks

