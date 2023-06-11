#!/bin/bash

# user mapping as regular user
## This is the nobody user
PS1='\u@app-user$ ' unshare -U
cat /proc/$$/uid_map

—----------------------------------

# This is the root user being created from a normal user
PS1='\u@app-user$ ' unshare -Ur
cat /proc/$$/uid_map

—-------------------------------


# This is the nested namespace creation
root@app-user$ PS1='\u@java-user$ ' unshare -Ur
root@java-user$ cat /proc/$$/uid_map
         0          0          1

—----------------------------------------------------

# as user 1
user1@rhel8-demo$ unshare -Ur
cd /tmp
touch user1_file
ls -l

# as user2
user2@rhel8-demo$ unshare -Ur
cd /tmp/
ls
echo "user2" >> user1_file

