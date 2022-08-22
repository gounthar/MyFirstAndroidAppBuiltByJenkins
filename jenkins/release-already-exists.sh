#!/bin/bash
# because of origin/master, we need to remove the first part of the branch name
GIT_BRANCH=$(echo "/$GIT_BRANCH" | sed 's/.*[/]//')
printVersionOptions=" "
if [[ "$GIT_BRANCH" != "main" && "$GIT_BRANCH" != "master" ]]; then {
  # We're not in the main branch, so alpha, beta or snapshot versions.
  printVersionOptions="-Palpha=true -Pbeta=true -Psnapshot=false"
} else {
  # We're in the main branch, so no more alpha, beta or snapshot versions.
  printVersionOptions="-Palpha=false -Pbeta=false -Psnapshot=false"
} fi
versionName=$(chmod +x ./gradlew && ./gradlew printVersion $printVersionOptions | grep "Version name:" | cut -d ' ' -f 3 | sed -e 's/^[[:space:]]*//')
# because of origin/master, we need to remove the first part of the branch name
GIT_BRANCH=$(echo "/$GIT_BRANCH" | sed 's/.*[/]//')
if [[ "$GIT_BRANCH" != "main" && "$GIT_BRANCH" != "master" ]]; then {
    # We're in a feature branch or whatever, so we'll use the branch name as a prefix
    versionName="-$GIT_BRANCH-$versionName"
} fi
# echo "Release version: ${versionName}"

versionCode=$(chmod +x ./gradlew && ./gradlew printVersion $printVersionOptions | grep "Version code:" | grep -o '[^ ]*$' | sed -e 's/^[[:space:]]*//')
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
