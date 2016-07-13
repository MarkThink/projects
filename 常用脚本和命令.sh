for i in $(kubectl get rc | grep -v auth-redis-slave | grep -v NAME | awk '{print $1}'); do kubectl scale rc $i --replicas=2; done

for i in $(kubectl get rc | grep -v auth-redis-slave | grep -v NAME | awk '{print $1}'); do kubectl scale rc $i --replicas=1; done

kubectl scale rc auth-redis-slave --replicas=3
for i in $(kubectl get rc | grep -v NAME | awk '{print $1}'); do kubectl scale rc $i --replicas=1; done
for i in $(kubectl --namespace=kube-system get rc | grep -v NAME | awk '{print $1}'); do kubectl --namespace=kube-system scale rc $i --replicas=1; done

for i in auth-server cluster-admin cluster-admin-server console-web console-web-redis kubernetes-admin paging; do kubectl scale rc $i --replicas=4; done

# kubelet
echo "" >> /etc/default/kubelet
echo "KUBELET_OPTS=\"\$KUBELET_OPTS --node-status-update-frequency=5s\"" >> /etc/default/kubelet
cat /etc/default/kubelet
service kubelet restart


# kube-controller-manager
echo "" >> /etc/default/kube-controller-manager
echo "KUBE_CONTROLLER_MANAGER_OPTS=\"\$KUBE_CONTROLLER_MANAGER_OPTS --node-monitor-grace-period=10s --horizontal-pod-autoscaler-sync-period=5s\"" >> /etc/default/kube-controller-manager
echo "KUBE_CONTROLLER_MANAGER_OPTS=\"\$KUBE_CONTROLLER_MANAGER_OPTS --pod-eviction-timeout=0m20s\"" >> /etc/default/kube-controller-manager
cat /etc/default/kube-controller-manager
service kube-controller-manager restart 

service etcd stop
service flanneld stop
service kubelet stop
umount -l $(mount | grep kubelet | awk '{print $3}')
docker rm -f $(docker ps -aq)
rm -rf /etc/default/etcd /etc/default/flanneld /etc/default/kube*
rm -rf /etc/init/etcd.conf /etc/init/flanneld.conf /etc/init/kube* 
rm -rf /etc/init.d/etcd /etc/init.d/flanneld /etc/init.d/kube* 
rm -rf /etc/kubernetes/ /etc/caicloud/
rm -rf /var/run/kubernetes/ /var/run/flannel/ /var/lib/kubelet/
rm -rf /opt/bin /kubernetes-master.etcd

cluster1
caicloudprivatetest.com
ubuntu:GuoHui19861225@10.57.60.137
ubuntu:GuoHui19861225@10.57.30.141
ubuntu:GuoHui19861225@10.57.60.219

etcdctl set /skydns/local/cluster/com/caicloudprivatetest/reg-proxy '{"host":"10.57.91.90"}'
etcdctl set /skydns/local/cluster/com/caicloudprivatetest/cluster1 '{"host":"10.57.60.137"}'

