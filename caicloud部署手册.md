# 1、部署k8s集群 #
https://github.com/caicloud/caicloud-kubernetes
```
MASTER_SSH_INFO=${MASTER_SSH_INFO:-"root:Speech!#2016@10.168.14.143"}
NODE_SSH_INFO=${NODE_SSH_INFO:-"root:Speech!#2016@10.168.111.78,root:Speech!#2016@10.168.109.243"}
REGISTER_MASTER_KUBELET=${REGISTER_MASTER_KUBELET:-"false"}
FLANNEL_TYPE="vxlan"
```
# 2、搭建registry #
- 修改厂家信息，需要修改的文件如下：
```
sed -i 's/ejinjiang/speech/g' start_registry.sh
```
- 修改域名
```
echo "10.168.109.243 docker-registry.speech.com" >> /etc/hosts
echo "10.168.109.243 docker-hub.speech.com" >> /etc/hosts
```
- 生成证书
```
openssl req -new > cert.csr
openssl rsa -in privkey.pem -out key.pem
openssl x509 -in cert.csr -out cert.pem -req -signkey key.pem -days 1001
```
- 登录index.caicloud.io
```
docker login -u caicloud -p caicloud2015ABC -e "729779963@qq.com" index.caicloud.io
```
- 部署registry
```
./start_registry.sh
```
- 修改docker daemon配置
```
DOCKER_OPTS="${DOCKER_OPTS} --insecure-registry=docker-registry.speech.com"
```
- 验证
```
docker login -u admin -p badmin -e "729779963@qq.com" docker-registry.speech.com
```
# 3、部署caicloud-stack
- auth-server
```
cd auth-server
caicloud create -f redis-rc.yaml; caicloud create -f redis-svc.yaml
caicloud create -f mongo-rc.yaml; caicloud create -f mongo-svc.yaml
caicloud create -f auth-server-rc.yaml; caicloud create -f auth-server-svc.yaml
```
- secrets
```
cd secrets/ssl-ejinjiang.com
caicloud create -f cds-executor-secret.yaml
caicloud get secrets
```
- cluster-manager
```
cd cluster-manager
caicloud create -f mongo-rc.yaml; caicloud create -f mongo-svc.yaml
caicloud create -f cds-server-rc.yaml && caicloud create -f cds-server-svc.yaml
caicloud create -f cds-executor-rc.yaml && caicloud create -f cds-executor-svc.yaml
caicloud create -f cds-validator-rc.yaml
```
- app-provisioner
```
cd app-provisioner
caicloud create -f mongo-rc.yaml && caicloud create -f mongo-svc.yaml
caicloud create -f app-provisioner-rc.yaml && caicloud create -f app-provisioner-svc.yaml
```
- portal-ui
  - 修改portal-ui/portal-ui-rc.yaml
```
image: index.caicloud.io/caicloud/portal-ui:v0.10.2
image: index.caicloud.io/caicloud/portal-ui:v0.10.9
```
```
value: jinjiang
value: bl
```
  - 创建
```
caicloud create -f portal-ui-rc.yaml
caicloud portal-ui-svc.yaml
```
