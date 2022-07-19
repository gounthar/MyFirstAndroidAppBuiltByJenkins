 #!/bin/sh

versionName=$(grep versionName ../app/build.gradle | cut -d '"' -f 2)
# echo "Release version: ${versionName}"

versionCode=$(grep versionCode ../app/build.gradle | grep -o '[^ ]*$')
# echo "Release version code: ${versionCode}"

echo $GITHUB_CREDENTIALS_PSW | gh auth login --with-token
existingRelease=$(gh release list | grep ${versionName} | cut -d$'\t' -f 1 | cut -c 2-)
# echo "Existing release is ${existingRelease}"
# echo "${existingRelease}"
result=$([ -z "$existingRelease" ] && echo "false" || echo "true")
echo "${result}"