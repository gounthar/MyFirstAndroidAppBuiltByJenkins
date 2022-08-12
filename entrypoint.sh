#!/bin/bash

set -eux -o pipefail

# Pre Hooks
# We could have something better by adjusting
# settings in daemon.json (maybe in /etc/docker/daemon.json)
dockerd --storage-driver=vfs --iptables=false &
# Run default entrypoint
exec /usr/local/bin/setup-sshd "$@"
