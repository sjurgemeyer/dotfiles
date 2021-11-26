# stop all running docker containers
function dsa () {
    docker stop $(docker ps -a -q)
}

# bring up the containers in ./docker-compose.yml
function dcu () {
    docker-compose up -d
}

# delete all containers, all containers must be stopped or an error will occur
function dda () {
    docker rm $(docker ps -a -q)
}

# stop all running containers, then bring up the containers in ./docker-compose.yml
function dra () {
    dsa
    dcu
}

# stop all containers, delete all containers, then bring up the containers in ./docker-compose.yml
function dockerHardReset () {
    dsa
    dda
    dcu
}

