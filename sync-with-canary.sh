rc_local=$(mktemp)
rc_canary=$(mktemp)
kubectl get rc -o wide | grep -v NAME > $rc_local

config_caicloud_canary=./config-caicloud-canary

cat $rc_local | while read LINE;
do

  # auth-mongo 1 1 34m mongo index.caicloud.io/caicloud/mongo:3.0.5 name=auth-mongo
  local_rc_name=$(echo $LINE | awk '{print $1}')
  local_rc_image=$(echo $LINE | awk '{print $6}')


  # 判断是否存在rc，不存在则跳过
  kubectl --kubeconfig=$config_caicloud_canary get rc $local_rc_name 1>/dev/null 2>/dev/null
  if [ "$?" != "0" ]; then
    continue
  fi

  canary_rc_name=$(kubectl --kubeconfig=$config_caicloud_canary get rc $local_rc_name -o wide | grep -v NAME | awk '{print $1}')
  canary_rc_image=$(kubectl --kubeconfig=$config_caicloud_canary get rc $local_rc_name -o wide | grep -v NAME | awk '{print $6}')


  echo "local : $local_rc_name=$local_rc_image"
  echo "canary: $canary_rc_name=$canary_rc_image"

  if [ "$local_rc_name" == "$local_rc_name" ]; then
    if [ "$local_rc_image" != "$canary_rc_image" ]; then
      
      echo -e "\033[31mupdate $local_rc_image to $canary_rc_image\033[0m"

      cmd="kubectl rolling-update $local_rc_name --image=$canary_rc_image"
      echo $cmd
      $cmd

    fi  
  fi

done
