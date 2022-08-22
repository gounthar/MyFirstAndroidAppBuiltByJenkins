#!/bin/bash

set -eux -o pipefail

# Pre Hooks
# Prepare Permissions by adding jenkins to the group owner of /var/run/docker.sock (this GID changes on different hosts/docker engines)
dockersock_growner_id="$(stat -c "%g" /var/run/docker.sock)"
if [[ "$dockersock_growner_id" == "0" ]]; then
  chown root:docker /var/run/docker.sock
else
  delgroup docker || true
  addgroup docker --gid "${dockersock_growner_id}"
fi
adduser jenkins docker
chmod 660 /var/run/docker.sock

# Run default entrypoint
exec /usr/local/bin/setup-sshd "$@"
