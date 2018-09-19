
declare -a environments=("dev" "stage" "prod")
declare -a cmds=("deployment" "configmap", "ingress")
for env in "${environments[@]}"
do
    for cmd in "${cmds[@]}"
    do
        eval "function k_${cmd}_${env}() { kubecommand $cmd $env \$* }"
    done
done

function kubecommand() {
    kubectl config use-context warehousing-$2-ttc
    kubectl get $1 $3 -o yaml
}
