#!/bin/bash

set -eux -o pipefail

# Pre Hooks
# Prepare Permissions by adding jenkins to the group owner of /var/run/docker.sock (this GID changes on different hosts/docker engines)
#dockersock_growner_id="$(stat -c "%g" /var/run/docker.sock)"
delgroup docker || true
addgroup docker --gid "${dockersock_growner_id}" || true
adduser jenkins docker
# Run default entrypoint
exec /usr/local/bin/setup-sshd "$@"
