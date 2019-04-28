declare -a environments=("dev" "stage" "prod")

function createS3Functions() {
    for i in "${environments[@]}"
    do
        eval "function ${1}_ls_${i}() { s3_ls $2 $i $3 \$* }"
        eval "function ${1}_get_${i}() { s3_get $2 $i $3 \$* \. }"
        eval "function ${1}_getpretty_${i}() { s3_get_pretty $2 $i $3 \$* }"
        eval "function ${1}_put_${i}() { s3_put $2 $i $3 \$* }"
    done
}
function s3_ls() {
    if [ "$3" = "ttc" ]; then
        aws s3 ls --endpoint-url https://ttc.toss.target.com --profile ttc --ca-bundle $TARGET_CERT s3://$1-$2/$4
    else
        echo "using default"
        aws s3 ls --endpoint-url https://toss.target.com --ca-bundle $TARGET_CERT s3://$1-$2/$3
    fi
}

function s3_get() {
    if [ "$3" = "ttc" ]; then
        aws s3 cp --endpoint-url https://ttc.toss.target.com --profile ttc --ca-bundle $TARGET_CERT s3://$1-$2/$4 $5
    else
        aws s3 cp --endpoint-url https://toss.target.com --ca-bundle $TARGET_CERT s3://$1-$2/$4 $5
    fi
}

function s3_get_pretty() {
    s3_get $1 $2 $3 $4 ./temp.json > /dev/null
    jq . ./temp.json > `basename $4`
    rm ./temp.json
}

function s3_put() {
    if [ "$3" = "ttc" ]; then
        aws s3 cp --endpoint-url https://ttc.toss.target.com --profile ttc --ca-bundle $TARGET_CERT $3 s3://$1-$2/$4
    else
        aws s3 cp --endpoint-url https://toss.target.com --ca-bundle $TARGET_CERT $3 s3://$1-$2/$4
    fi
}

createS3Functions dci ole-decorated-dci-bucket ttc
createS3Functions originaldci ole-original-dci-bucket ttc
createS3Functions batch ole-batch-bucket ttc
createS3Functions asset ole-asset-bucket ttc
createS3Functions inv inventory-data-load-bucket default

