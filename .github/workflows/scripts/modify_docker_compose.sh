#!/bin/bash

# Define the version you want to install
REQUIRED_VERSION="4.2.0"

# Check if yq is installed
if ! command -v yq &> /dev/null
then
    echo "yq could not be found, installing..."
    INSTALL_YQ=true
else
    # Check the version of yq
    CURRENT_VERSION=$(yq --version | cut -d' ' -f3)

    # Use sort -V to compare the version numbers
    if [[ $(echo -e "$CURRENT_VERSION\n$REQUIRED_VERSION" | sort -V | head -n1) != "$REQUIRED_VERSION" ]]
    then
        echo "yq version is less than $REQUIRED_VERSION, upgrading..."
        INSTALL_YQ=true
    else
        echo "yq is already at version $REQUIRED_VERSION or later"
        INSTALL_YQ=false
    fi
fi

# Install or upgrade yq if necessary
if [ "$INSTALL_YQ" = true ]
then
    VERSION=v4.2.0
    BINARY=yq_linux_amd64

    wget https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY}.tar.gz -O - |\
    tar xz && sudo mv ${BINARY} /usr/bin/yq
fi

# Navigate to the jenkins directory
cd jenkins || exit

# Make a copy of the original docker-compose file
cp docker-compose.yml docker-compose-plugins.yml

# Use yq to modify the docker-compose file
yq e 'del(.services.emulator)' docker-compose-plugins.yml -i
yq e 'del(.services.stf)' docker-compose-plugins.yml -i
yq e 'del(.services.adb-connector)' docker-compose-plugins.yml -i
yq e 'del(.services.adb)' docker-compose-plugins.yml -i
yq e 'del(.services.rethinkdb)' docker-compose-plugins.yml -i

# Navigate back to the original directory
cd ..
