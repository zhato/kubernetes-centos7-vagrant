#!/bin/bash

MASTERIP=$1
TOKEN=$2

sed "s/127.0.0.1.*master/$MASTERIP master/" -i /etc/hosts

echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables

kubeadm init \
--apiserver-advertise-address=$MASTERIP \
--apiserver-bind-port=8080 \
--token=$TOKEN \
--pod-network-cidr 10.244.0.0/16 \
--token-ttl 0

mkdir -p $HOME/.kube
sudo /bin/cp -a /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
sudo /bin/cp -a /etc/kubernetes/admin.conf /shared

kubectl apply -f /shared/kube-flannel.yml
kubectl apply -f /shared/kube-flannel-rbac.yml
