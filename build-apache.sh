#!/bin/bash
IMAGE="jarek/apachephp"
docker rmi -f $IMAGE
docker build -t $IMAGE .

