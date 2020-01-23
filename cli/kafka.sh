#DOC print daily dead letter summary
function daily() {
    consume prod tte ole ole-dead-letter
    groovy parseDaily.groovy
}

