#!/bin/bash -x

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
versionName=$(./gradlew printVersion $printVersionOptions | grep "Version name:" | cut -d ' ' -f 3 | sed -e 's/^[[:space:]]*//')
# because of origin/master, we need to remove the first part of the branch name
GIT_BRANCH=$(echo "/$GIT_BRANCH" | sed 's/.*[/]//')
if [[ "$GIT_BRANCH" != "main" && "$GIT_BRANCH" != "master" ]]; then {
    # We're in a feature branch or whatever, so we'll use the branch name as a prefix
    versionName="-$GIT_BRANCH-$versionName"
} fi
echo "Release version: ${versionName}"
# -d Save the release as a draft instead of publishing it...
# -p Mark the release as a prerelease
# Prerelease should be better for alpha or beta versions... So we should create a GH_OPTS variable to set this.
# We should detect if the version contains "RELEASE" to make a real release or not
# We should detect if the version contains "ALPHA" or "BETA" to make a pre-release or not
# We should detect if the version contains "SNAPSHOT" to not make a release at all
GH_OPTS=" "

# Functions

suffix=$(echo $versionName | sed 's/.*-//')
case $suffix in
    ALPHA|BETA)
        echo "Time to do a prerelease"
        GH_OPTS="$GH_OPTS-p"
        ;;
    SNAPSHOT)
        echo "This is a snapshot, we won't release anything"
        GH_OPTS="$GH_OPTS DO_NOT_RELEASE"
        ;;
    RELEASE)
        echo "This a real release, so no need to use -d or -p";;
    *)
        echo "Unknown suffix \"$suffix\", so we'll do a draft release"
        GH_OPTS="$GH_OPTS-d"
        ;;
esac

echo "GH_OPTS is $GH_OPTS"
if [[ "$GH_OPTS" =~ .*"DO_NOT_RELEASE".* ]]; then
  echo "It's not considered as a release, do nothing."
  else {
    echo "It's a release, so we'll publish it."
    echo $GITHUB_CREDENTIALS_PSW | gh auth login --with-token
    # We should prefix the version with v to make it a valid tag and then the branch name
    chmod +x ./gradlew && ./gradlew build || true
    gh release create v$versionName --generate-notes $GH_OPTS ./app/build/outputs/apk/**/*apk
} fi
