#!/bin/bash 

ENVFILE=./00-setenv.sh

# env
if [ -f $ENVFILE ];then
  . $ENVFILE
else
  echo "$ENVFILE not found!"
  exit 
fi

# deploy
test ! -d $docker_pkg_dir && echo "$docker_pkg_dir not found!" && exit 1
cd $docker_pkg_dir && yum install -y *.rpm

# disable firewalld & selinux
systemctl daemon-reload
systemctl disable firewalld
systemctl stop firewalld
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config

# reset 
systemctl enable docker
systemctl restart docker
systemctl status -l docker
