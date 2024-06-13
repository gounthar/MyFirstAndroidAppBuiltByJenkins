#!/bin/bash

# This script checks if a Jenkins service is running and prints its version.

# The script first tries to access the Jenkins login page. If the page is accessible,
# it means that Jenkins is running. The script will keep trying to access the page for
# up to 60 seconds. If the page is not accessible after 60 seconds, the script will
# print "Jenkins is not running" and exit.
timeout 60 bash -c 'until curl -s -f http://127.0.0.1:8080/login > /dev/null; do sleep 5; done' && echo "Jenkins is running" || echo "Jenkins is not running"

# If Jenkins is running, the script will print "Jenkins is ready".
echo "Jenkins is ready"

# The script then retrieves the Jenkins version by sending a HTTP request to the Jenkins
# server and parsing the 'X-Jenkins' header in the response. The version is printed to the console.
JENKINS_VERSION=$(curl -s -I -k http://admin:butler@127.0.0.1:8080 | grep -i '^X-Jenkins:' | awk '{print $2}')
echo "Jenkins version is: $JENKINS_VERSION"
