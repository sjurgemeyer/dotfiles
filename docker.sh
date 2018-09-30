function dsa () {
    docker stop $(docker ps -a -q)
}

function dsu () {
    dsa
    dcu
}

function dda () {
    docker rm $(docker ps -a -q)
}

function dcu () {
    docker-compose up -d
}
