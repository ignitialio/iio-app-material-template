#!/bin/sh

export IIOS_DLAKE_VERSION=3.5.1
export IIOS_AUTH_VERSION=1.3.0

docker network create --opt encrypted -d overlay infra
docker stack deploy -c swarm/docker-compose.yml iioat
