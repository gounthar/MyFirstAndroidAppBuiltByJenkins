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
versionName=$(chmod +x ./gradlew && ./gradlew printVersion $printVersionOptions | grep "Version name:" | cut -d ' ' -f 3 | sed -e 's/^[[:space:]]*//')
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
publishOnPlayStore(){
    echo "Publishing on Google Play Store"
    # Because the tool expects to see the release notes in that kind of directory
    # This should definitely be coined via reading/understanding build.gradle, and not hardcoded
    # cf https://github.com/Triple-T/gradle-play-publisher#uploading-release-notes
    releaseNotesDir=app/src/main/play/release-notes/en-US
    releaseNamesDir=app/src/main/play/release-names
    mkdir -p $releaseNotesDir && mkdir -p $releaseNamesDir
    # Same in here of course, internal can be found in the `play` section of build.gradle
    # We have to get the release notes as small as possible, as Google wants at max 500 characters...
    # So we strip everything before "--"
    # title:  v1.0.7-ALPHA
    # tag:    v1.0.7-ALPHA
    # draft:  false
    # prerelease:     true
    # author: myjenkinsinstancev[bot]
    # created:        2022-07-21T15:35:12Z
    # published:      2022-07-23T17:45:05Z
    # url:    https://github.com/gounthar/MyFirstAndroidAppBuiltByJenkins/releases/tag/v1.0.7-ALPHA
    # asset:  app-debug.apk
    # asset:  app-release.apk
    # --
    gh release view v${versionName} | grep -A 500 "\-\-" | grep -v "\-\-" | sed 's/http.*[/]/#/' > $releaseNotesDir/internal.txt
    content=$(cat < "$releaseNotesDir/internal.txt" && echo .) && content=${content%.} && printf %s "${content:0:500}" > "$releaseNotesDir/internal.txt"
    # Strangely, the published version is still attached to the 1.0.3 "release". We have to find out why, and what kind
    # of parameter to pass so that the tool can find the right release.
    # That could be linked to the release names. Let's try out
    # https://github.com/Triple-T/gradle-play-publisher#uploading-developer-facing-release-names
    # Note: the Play Store limits your release names to a maximum of 50 characters.
    printf %s "${versionName:0:500}" > $releaseNamesDir/internal.txt
    chmod +x ./gradlew && ./gradlew publishBundle
}

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
    # Let's tackle with the Google Play Store
    publishOnPlayStore
} fi
