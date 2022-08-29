#!/usr/bin/env bash

apt-get update && apt-get install -y curl
curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
usermod -aG docker vagrant
docker compose up -d --build --force-recreate &
