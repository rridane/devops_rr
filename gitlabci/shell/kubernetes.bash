function kubernetes__deploy_cron() {

    CRON=$(kubectl get cronjob -n administration -l tier="etcd" )

    if [ -z "$CRON" ]
    then
      echo "first deploy on kubernetes"
    else
      echo "Deleting deploy before apply"
      kubectl delete -f ./ci/kubernetes/etcd_cron.yaml
    fi

    kubectl apply -f ./ci/kubernetes/etcd_cron.yaml

}

# $1 namespace
function kubernetes__deploy_pod() {

    CRON=$(kubectl get pod -n $1 -l tier="etcd" )

    if [ -z "$CRON" ]
    then
      echo "first deploy on kubernetes"
    else
      echo "Deleting deploy before apply"
      kubectl delete -f ./ci/kubernetes/pod.yaml
    fi

    kubectl apply -f ./ci/kubernetes/pod.yaml

}
