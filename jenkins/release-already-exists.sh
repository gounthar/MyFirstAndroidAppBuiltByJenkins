 #!/bin/sh

versionName=$(./gradlew printVersion | grep "Version name:" | cut -d ' ' -f 3 | sed -e 's/^[[:space:]]*//')
# echo "Release version: ${versionName}"

versionCode=$(./gradlew printVersion | grep "Version code:" | grep -o '[^ ]*$' | sed -e 's/^[[:space:]]*//')
# echo "Release version code: ${versionCode}"

# echo $GITHUB_CREDENTIALS_PSW | gh auth login --with-token
lookAlikeExistingRelease=$(gh release list | grep $versionName | cut -d$'\t' -f 1 | cut -c 2-)
# echo "Existing release for $versionName : $lookAlikeExistingRelease"

result=$([ -z "$lookAlikeExistingRelease" ] && echo "" || echo "$lookAlikeExistingRelease")
[ -z "$result" ] && echo -n "false" || echo -n "true"