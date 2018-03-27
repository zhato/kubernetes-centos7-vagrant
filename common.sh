#!/bin/bash

setenforce 0
systemctl disable firewalld && systemctl stop firewalld
sed 's/^SELINUX=enforcing/SELINUX=disabled/g' -i /etc/selinux/config
sed 's/^PasswordAuthentication no/PasswordAuthentication yes/g' -i /etc/ssh/sshd_config
systemctl restart sshd

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

yum install -y docker
systemctl enable docker && systemctl restart docker

yum install -y kubelet kubeadm
systemctl enable kubelet && systemctl restart kubelet

yum -y update
