#!/bin/bash

## !IMPORTANT ##
#
echo "[TASK 1] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
192.168.201.155  load-balancer hub.df.ggg.com.vn
192.168.201.154  master-node-1
192.168.201.49   master-node-2
192.168.201.46   worker-node-1
192.168.201.47   worker-node-2
192.168.201.160  worker-node-3
192.168.201.160  grafana.df.ggg.com.vn
192.168.201.160  jenkins.df.ggg.com.vn
192.168.201.160  rancher.df.ggg.com.vn  
EOF

echo "[TASK 2] Install HAProxy"
apt-get update && apt-get install -y haproxy

echo "[TASK 3] Update HAProxy configs /etc/haproxy/haproxy.cfg"
cat >>/etc/haproxy/haproxy.cfg<<EOF

frontend kubernetes-frontend
    bind *:6443
    mode tcp
    option tcplog
    default_backend kubernetes-backend

backend kubernetes-backend
    mode tcp
    option tcp-check
    balance roundrobin
    server kmaster1 master-node-1:6443 check fall 3 rise 2
    server kmaster2 master-node-2:6443 check fall 3 rise 2
EOF

echo "[TASK 4] Restart HAProxy service"
systemctl restart haproxy.service
