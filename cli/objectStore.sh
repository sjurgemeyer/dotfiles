declare -a environments=("dev" "stage" "prod")

function createS3Functions() {
    for i in "${environments[@]}"
    do
        eval "function ${1}_ls_${i}() { s3_ls $2 $i \$* }"
        eval "function ${1}_get_${i}() { s3_get $2 $i \$* \. }"
        eval "function ${1}_getpretty_${i}() { s3_get_pretty $2 $i \$* }"
        eval "function ${1}_put_${i}() { s3_put $2 $i \$* }"
    done
}
function s3_ls() {
    aws s3 ls --endpoint-url https://toss.target.com --ca-bundle $TARGET_CERT s3://$1-$2/$3
}

function s3_get() {
    aws s3 cp --endpoint-url https://toss.target.com --ca-bundle $TARGET_CERT s3://$1-$2/$3 $4
}

function s3_get_pretty() {
    s3_get $1 $2 $3 ./temp.json > /dev/null
    jq . ./temp.json > `basename $3`
    rm ./temp.json
}

function s3_put() {
    aws s3 cp --endpoint-url https://toss.target.com --ca-bundle $TARGET_CERT $3 s3://$1-$2/$3
}

createS3Functions dci ole-decorated-dci-bucket
createS3Functions originaldci ole-original-dci-bucket
createS3Functions batch ole-batch-bucket

