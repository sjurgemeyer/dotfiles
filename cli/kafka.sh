function daily() {
    consume prod tte ole ole-dead-letter
    groovy parseDaily.groovy
}

function consume() {
    env="${1}"
    datacenter="${2}"
    cluster="${3}"
    topic="${4}"

    namespace="warehousing-${env}-${datacenter}"
    configmap=kafka-ole

    if [ "${cluster}" = "tgt" ]; then
        configmap=event-inbox
    fi
    if [ "${cluster}" = "bg" ]; then
        configmap=automation-berkshire
    fi

    echo "Getting Kafka Server from ${configmap} in namespace ${namespace}"
    kafka_server=`kubectl get configmap --context ${namespace} ${configmap} -o yaml \
        | grep '^ *WMS__KAFKA__SERVERS:' \
        | sed -e 's/.*WMS__KAFKA__SERVERS: //' -e 's/,.*//' `

    temp_key_path=`mktemp -d`
    echo "listening to ${kafka_server}"

    prop_file=${temp_key_path}/ssl.properties

    # Just put these somewhere you can reference them
    echo "Getting Kafka Trust Store"
    gopass bin cp ole-k8s/${env}/kafka/client.truststore.jks.b64 /${temp_key_path}/client.truststore.jks
    echo "Getting Kafka Key Store"
    gopass bin cp ole-k8s/${env}/kafka/server.keystore.jks.b64 /${temp_key_path}/server.keystore.jks
    echo "Getting Kafka Trust Store Passphrase"
    keystore_passphrase=`gopass ole-k8s/${env}/kafka/kafka-keystore-passphrase| sed -e 's/\\\\/\\\\\\\\/'`
    echo "Getting Kafka Key Store Passphrase"
    truststore_passphrase=`gopass ole-k8s/${env}/kafka/kafka-truststore-passphrase| sed -e 's/\\\\/\\\\\\\\/'`


    echo "Building ${prop_file}"
    echo "security.protocol=SSL
    ssl.truststore.location=${temp_key_path}/client.truststore.jks
    ssl.truststore.password=${truststore_passphrase}
    ssl.keystore.location=${temp_key_path}/server.keystore.jks
    ssl.keystore.password=${keystore_passphrase}" > ${prop_file}

    cat ${prop_file}

    echo "Consuming from topic: ${topic} on server: ${kafka_server}"
    kafka-console-consumer.sh \
        --bootstrap-server ${kafka_server} \
        --timeout-ms 3000 \
        --topic ${topic} \
        --consumer.config ${prop_file} \
        --from-beginning >> ${topic}-messages.json

    # Clean up after ourselves
    rm -rf ${temp_key_path}

}
