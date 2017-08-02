#!/bin/bash

MASTERIP=$1
TOKEN=$2
NODEIP=$3
SEQ=$4

sed "s/127.0.0.1.*node-$SEQ/$NODEIP node-$SEQ/" -i /etc/hosts

echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables

kubeadm join --node-name `hostname` --token $TOKEN $MASTERIP:8080
