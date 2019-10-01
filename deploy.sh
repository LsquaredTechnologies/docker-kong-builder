#!/bin/bash
echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
docker push eliauren/kong-builder:1.2-centos
