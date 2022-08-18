#!/bin/bash

set -eux -o pipefail

# Pre Hooks
# We could have something better by adjusting
# settings in daemon.json (maybe in /etc/docker/daemon.json)
# because of failed to start daemon: pid file found, ensure docker is not running or delete /var/run/docker.pid
# rm -rf /var/run/docker*
# dockerd --storage-driver=vfs --iptables=false &
# Run default entrypoint
exec /usr/local/bin/setup-sshd "$@"
