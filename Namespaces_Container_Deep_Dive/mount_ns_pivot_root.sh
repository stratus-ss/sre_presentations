#!/bin/bash

# As root user
export CONTAINER_ROOT_FOLDER=/container_practice
mkdir -p ${CONTAINER_ROOT_FOLDER}/fakeroot
cd ${CONTAINER_ROOT_FOLDER}
wget https://dl-cdn.alpinelinux.org/alpine/v3.17/releases/x86_64/alpine-minirootfs-3.17.0-x86_64.tar.gz
tar xvf alpine-minirootfs-3.17.0-x86_64.tar.gz -C fakeroot
chown container-user. -R ${CONTAINER_ROOT_FOLDER}/fakeroot


su - container-user
export CONTAINER_ROOT_FOLDER=/container_practice

PS1='\u@new-mnt$ ' unshare -Urm

# inside namespace
findmnt
mount --bind ${CONTAINER_ROOT_FOLDER}/fakeroot ${CONTAINER_ROOT_FOLDER}/fakeroot
cd ${CONTAINER_ROOT_FOLDER}/fakeroot
mkdir old_root
pivot_root . old_root

findmnt

PATH=/bin:/sbin:$PATH
umount -l /old_root

# apk is the package manager in 
apk -h
