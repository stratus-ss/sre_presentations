#!/bin/bash

# As user1
user1@rhel8-demo$ unshare -Ur
sleep 1000

# as user2
user2@rhel8-demo$ unshare -Ur
ps aux |grep "sleep 1000" |head -n 1
SLEEP_PID=$(ps aux |grep "sleep 1000" |head -n 1 |awk '{ print $2}')
kill -9 $SLEEP_PID
—--------------------------------------------------

# As a regular user create the first namespace
PS1='\u@app-user$ ' unshare -Ur
cat /proc/$$/uid_map

# create the second namespace from inside the first
root@app-user$ PS1='\u@java-user$ ' unshare -Ur
root@java-user$ cat /proc/$$/uid_map

—---------------------------------------------
# Process creation
## Shell 1
PS1='\u@app-user$ ' unshare -Ur
sleep 100000

## Shell 2
PID=$(ps aux |grep "sleep 1000" |grep -v grep |awk '{print $2}')
readlink /proc/${PID}/ns/user 
readlink /proc/$$/ns/user
—---------------------------------------

# You can only write to the mapping once
unshare -U
touch UID_test
watch ‘ls -l’

# from the root user in another shell
## find the PID of the BASH process

ps aux |grep bash |grep user1
echo "1000 1000 1" > /proc/<pid>/uid_map

