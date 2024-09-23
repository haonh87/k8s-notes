#!/bin/bash

echo "[TASK 1] Pull required containers"
kubeadm config images pull

echo "[TASK 2] Initialize Kubernetes Cluster"
kubeadm init --control-plane-endpoint="192.168.201.155:6443" --upload-certs --apiserver-advertise-address=192.168.201.154 --pod-network-cidr=10.244.0.0/16
echo "[TASK 3] Deploy flannel network"
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml >/dev/null

# You can now join any number of the control-plane node running the following command on each as root:
# IMPORTANT: You also need to pass --apiserver-advertise-address to the join command when you join the other master node.