declare -a environments=("dev" "stage" "prod")
for i in "${environments[@]}"
do
   eval "function s3_ls_${i}() { s3_ls $i \$* }"
   eval "function s3_get_${i}() { s3_get $i \$* }"
   eval "function s3_put_${i}() { s3_put $i \$* }"
done

function s3_ls() {
    aws s3 ls --endpoint-url https://toss.target.com --ca-bundle $TARGET_CERT s3://ole-batch-bucket-$1/$2
}

function s3_get() {
    aws s3 cp --endpoint-url https://toss.target.com --ca-bundle $TARGET_CERT s3://ole-batch-bucket-$1/$2 .
}

function s3_put() {
    aws s3 cp --endpoint-url https://toss.target.com --ca-bundle $TARGET_CERT $3 s3://ole-batch-bucket-$1/$2
}
