 #!/bin/sh

versionName=$(./gradlew printVersion | grep "Version name:" | cut -d ' ' -f 3)
# echo "Release version: ${versionName}"

versionCode=$(./gradlew printVersion | grep "Version code:" | grep -o '[^ ]*$')
# echo "Release version code: ${versionCode}"

echo $GITHUB_CREDENTIALS_PSW | gh auth login --with-token
lookAlikeExistingRelease=$(gh release list | grep $versionName)
result=$([ -z "$lookAlikeExistingRelease" ] && echo "" || echo "$lookAlikeExistingRelease" | cut -d$'\t' -f 1 | cut -c 2-)

[ -z "$result" ] && echo -n "false" || echo -n "true"