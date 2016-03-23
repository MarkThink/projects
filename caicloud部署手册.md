# 1、部署k8s集群
**https://github.com/caicloud/caicloud-kubernetes**
```
MASTER_SSH_INFO=${MASTER_SSH_INFO:-"root:Speech!#2016@10.168.14.143"}
NODE_SSH_INFO=${NODE_SSH_INFO:-"root:Speech!#2016@10.168.111.78,root:Speech!#2016@10.168.109.243"}
REGISTER_MASTER_KUBELET=${REGISTER_MASTER_KUBELET:-"false"}
FLANNEL_TYPE="vxlan"
```
# 2、搭建registry
**https://github.com/caicloud/caicloud-docker-registry**
- 修改厂家信息
```
$grep -rn "jinjiang" .
./start_registry.sh:30:  running=$(docker ps -a -q -f 'name=jinjiang-registry')
./start_registry.sh:32:    echo "Found a running jinjiang-registry instance, deleting it first"
./start_registry.sh:38:    --name jinjiang-registry \
./start_registry.sh:58:    -e ENV_DOCKER_REGISTRY_HOST=docker-registry.ejinjiang.com \
./config-with-auth.yml:35:    realm: https://docker-registry.ejinjiang.com:3000/auth
./config-with-auth.yml:36:    service: docker-registry.ejinjiang.com
./config-with-auth.yml:37:    issuer: docker-registry.ejinjiang.com
./nginx.conf:29:    # Virtual server for docker-registry.ejinjiang.com.
./nginx.conf:32:        server_name docker-registry.ejinjiang.com;
./nginx.conf:37:        server_name docker-registry.ejinjiang.com;
./nginx.conf:86:    # Virtual server for docker-hub.ejinjiang.com.
./nginx.conf:90:        server_name docker-hub.ejinjiang.com;
./auth-config/config-auth.yml:7:  issuer: "docker-registry.ejinjiang.com"  # Must match issuer in the Registry config.

sed -i 's/ejinjiang/speech/g' start_registry.sh
```
- 修改域名
```
ip="10.168.109.243"; \
echo "$ip docker-registry.speech.com" >> /etc/hosts; \
echo "$ip docker-hub.speech.com" >> /etc/hosts;
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
**https://github.com/caicloud/caicloud-jinjiang**
```
cd auth-server
caicloud create -f redis-rc.yaml; caicloud create -f redis-svc.yaml
caicloud create -f mongo-rc.yaml; caicloud create -f mongo-svc.yaml
caicloud create -f auth-server-rc.yaml; caicloud create -f auth-server-svc.yaml

cd secrets/ssl-ejinjiang.com
caicloud create -f cds-executor-secret.yaml
caicloud get secrets

cd cluster-manager
caicloud create -f mongo-rc.yaml; caicloud create -f mongo-svc.yaml
caicloud create -f cds-server-rc.yaml && caicloud create -f cds-server-svc.yaml
caicloud create -f cds-executor-rc.yaml && caicloud create -f cds-executor-svc.yaml
caicloud create -f cds-validator-rc.yaml

cd app-provisioner
caicloud create -f mongo-rc.yaml && caicloud create -f mongo-svc.yaml
caicloud create -f app-provisioner-rc.yaml && caicloud create -f app-provisioner-svc.yaml
```
