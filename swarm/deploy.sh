#!/bin/sh

export IIOS_DLAKE_VERSION=3.4.1
export IIOS_AUTH_VERSION=1.2.1

docker network create --opt encrypted -d overlay infra
docker stack deploy -c swarm/docker-compose.yml iioat
