
declare -a environments=("dev" "stage" "prod")
declare -a cmds=("deployment" "configmap" "ingress")
for env in "${environments[@]}"
do
    for cmd in "${cmds[@]}"
    do
        eval "function k_${cmd}_${env}() { kubecommand $cmd $env \$* | bat -l yaml }"
    done
done

function kubecommand() {
    kubectl config use-context warehousing-$2-ttc
    kubectl get $1 $3 -o yaml
}


declare -a tapcmds=("deployment" "config" "secret")
for env in "${environments[@]}"
do
    for cmd in "${tapcmds[@]}"
    do
        tapenv=dev
        if [ "prod" = "$env" ]; then
            tapenv=prod
        fi
        eval "function t_${cmd}_${env}() { tapcommand $cmd $tapenv $env \$* | bat -l yaml }"
    done
done

function tapcommand() {
    tapctl get $1 application.yml -c=$4-$3 -e=$2
}
