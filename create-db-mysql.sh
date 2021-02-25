#!/bin/bash

set -e

CONTAINER_NAME='mysql'
VOLUME='mysql-volume'
ROOT_PASSWD='mysql'

docker volume create "$VOLUME"

docker run \
    --name="$CONTAINER_NAME" \
    -v "$VOLUME":/var/lib/mysql \
    -e MYSQL_ROOT_PASSWORD="$ROOT_PASSWD" \
    -p 3306:3306 \
    -d \
    mysql/mysql-server:latest
