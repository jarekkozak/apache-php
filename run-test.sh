#!/bin/bash
docker rm -f apache-test
docker run -d -p 0.0.0.0:80:80 --name apache-test jarek/apachephp
docker ps

