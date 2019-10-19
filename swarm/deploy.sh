#!/bin/sh

export IIOS_APP_VERSION=1.0.0
export IIOS_DLAKE_VERSION=3.1.0
export IIOS_AUTH_VERSION=1.1.0

docker network create --opt encrypted -d overlay infra
docker stack deploy -c swarm/docker-compose.yml iioat
