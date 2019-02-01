#!/bin/bash

# REMOVE CONTAINERS
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

#REMOVE IMAGES
#docker rmi $(docker images -a -q)


