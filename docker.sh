function dsa () {
    docker stop $(docker ps -a -q)
}

function dra () {
    dsa
    dcu
}

function dsu () {
    dsa
    dcu
}

function dockerHardReset () {
    dsa
    dda
    dcu
}

function dda () {
    docker rm $(docker ps -a -q)
}

function dcu () {
    docker-compose up -d
}
