#!/bin/sh

versionName=$(./gradlew printVersion | grep "Version name:" | cut -d ' ' -f 3 | sed -e 's/^[[:space:]]*//')
# echo "Release version: ${versionName}"

versionCode=$(./gradlew printVersion | grep "Version code:" | grep -o '[^ ]*$' | sed -e 's/^[[:space:]]*//')
# echo "Release version code: ${versionCode}"

echo $GITHUB_CREDENTIALS_PSW | gh auth login --with-token
existingRelease=$(gh release list | grep -F $versionName | head -1)
lookAlikeExistingRelease=

[ -z "$existingRelease" ] || {
# echo "Release $versionName already exists ($existingRelease)"
  lookAlikeExistingRelease=$(echo $existingRelease | sed -e 's/\t/ /g')
# echo "Tab to space: $lookAlikeExistingRelease"
  lookAlikeExistingRelease=$(echo $lookAlikeExistingRelease | cut -d ' ' -f 1)
# echo "Remove spaces: $lookAlikeExistingRelease"
  lookAlikeExistingRelease=$(echo $lookAlikeExistingRelease | cut -c 2-)
# echo "Cut from 2nd character: $lookAlikeExistingRelease"
}
# echo "Existing release for $versionName : $lookAlikeExistingRelease"

result=$([ -z "$lookAlikeExistingRelease" ] && echo "" || echo "$lookAlikeExistingRelease")
[ -z "$result" ] && echo -n "false" || echo -n "true"