#!/bin/bash

# This script is used to install or upgrade the 'yq' command-line tool to a specific version.
# It also modifies a docker-compose file by removing certain services.

# Define the version you want to install
REQUIRED_VERSION="4.2.0"

# Check if yq is installed
if ! command -v yq &> /dev/null
then
    # If yq is not found, print a message and set the INSTALL_YQ flag to true
    echo "yq could not be found, installing..."
    INSTALL_YQ=true
else
    # If yq is found, check its version
    CURRENT_VERSION=$(yq --version | cut -d' ' -f3)

    # If the current version is less than the required version, print a message and set the INSTALL_YQ flag to true
    if [[ $(echo -e "$CURRENT_VERSION\n$REQUIRED_VERSION" | sort -V | head -n1) != "$REQUIRED_VERSION" ]]
    then
        echo "yq version is less than $REQUIRED_VERSION, upgrading..."
        INSTALL_YQ=true
    else
        # If the current version is equal to or greater than the required version, print a message and set the INSTALL_YQ flag to false
        echo "yq is already at version $REQUIRED_VERSION or later"
        INSTALL_YQ=false
    fi
fi

# Install or upgrade yq if necessary
if [ "$INSTALL_YQ" = true ]
then
    VERSION=v4.2.0
    # Get the operating system name
    OS=$(uname | tr '[:upper:]' '[:lower:]')

    # Get the machine hardware name
    ARCH=$(uname -m)

    # Map the machine hardware name to the value used in the yq binary names
    if [ "$ARCH" = "x86_64" ]; then
        ARCH="amd64"
    elif [ "$ARCH" = "aarch64" ]; then
        ARCH="arm64"
    elif [ "$ARCH" = "armv7l" ]; then
        ARCH="arm"
    fi

    # Construct the binary name
    BINARY="yq_${OS}_${ARCH}"

    # Download the yq binary for the specific OS and architecture, extract it, and move it to /usr/bin
    wget https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY}.tar.gz -O - |\
    tar xz && sudo mv ${BINARY} /usr/bin/yq
fi

# Navigate to the jenkins directory
cd jenkins || exit

# Make a copy of the original docker-compose file
cp docker-compose.yml docker-compose-plugins.yml

# Use yq to modify the docker-compose file by removing certain services
yq e 'del(.services.emulator)' docker-compose-plugins.yml -i
yq e 'del(.services.stf)' docker-compose-plugins.yml -i
yq e 'del(.services.adb-connector)' docker-compose-plugins.yml -i
yq e 'del(.services.adb)' docker-compose-plugins.yml -i
yq e 'del(.services.rethinkdb)' docker-compose-plugins.yml -i

# Navigate back to the original directory
cd ..
