#!/bin/bash

MASTERIP=$1
TOKEN=$2
NODEIP=$3
SEQ=$4

swapoff -a

# cd /opt/cni/bin
# tar zxvf /shared/cni-plugins-amd64-v0.6.0.tgz
# tar zxvf /shared/cni-amd64-v0.6.0.tgz

sed "s/127.0.0.1.*node-$SEQ/$NODEIP node-$SEQ/" -i /etc/hosts

echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables

kubeadm join --node-name `hostname` --token $TOKEN $MASTERIP:8080 --discovery-token-ca-cert-hash sha256:4766ee54613da5d4015d1ff5fe349d0b7d0f5821957c258ea5968723f2a5bd34
