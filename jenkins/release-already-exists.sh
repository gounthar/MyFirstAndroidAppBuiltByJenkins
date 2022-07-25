#!/bin/bash -x

versionName=$(./gradlew printVersion -Palpha=true -Pbeta=true | grep "Version name:" | cut -d ' ' -f 3 | sed -e 's/^[[:space:]]*//')
# because of origin/master, we need to remove the first part of the branch name
GIT_BRANCH=$(echo "/$GIT_BRANCH" | sed 's/.*[/]//')
if [[ "$GIT_BRANCH" != "main" && "$GIT_BRANCH" != "master" ]]; then {
    # We're in a feature branch or whatever, so we'll use the branch name as a prefix
    versionName="$GIT_BRANCH-$versionName"
} fi
# echo "Release version: ${versionName}"

versionCode=$(./gradlew printVersion -Palpha=true -Pbeta=true | grep "Version code:" | grep -o '[^ ]*$' | sed -e 's/^[[:space:]]*//')
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