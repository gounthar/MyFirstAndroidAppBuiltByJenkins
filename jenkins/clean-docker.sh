#!/bin/sh
docker ps -q | xargs docker kill; docker system prune --volumes --force