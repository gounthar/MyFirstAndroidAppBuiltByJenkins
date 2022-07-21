#!/bin/sh

versionName=$(./gradlew printVersion | grep "Version name:" | cut -d ' ' -f 3 | sed -e 's/^[[:space:]]*//')
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
    mkdir -p $releaseNotesDir
    # Same in here of course, internal can be found in the `play` section of build.gradle
    script -q -c "gh release view ${versionName}" $releaseNotesDir/internal.txt >/dev/null
    ./gradlew publishBundle
}

suffix=$(echo $versionName | sed 's/.*-//')
case $suffix in
    ALPHA|BETA)
        echo "Time to do a prerelease"
        GH_OPTS="$GH_OPTS-p"
        ;;
    SNAPSHOT)
        echo "This is a snapshot, we won't release anything"
        GH_OPTS="$GH_OPTSDO_NOT_RELEASE"
        ;;
    RELEASE)
        echo "This a real release, so no need to use -d or -p";;
    *)
        echo "Unknown suffix \"$suffix\", so we'll do a draft release"
        GH_OPTS="$GH_OPTS-d"
        ;;
esac

if [[ "$GH_OPTS" == *"DO_NOT_RELEASE"* ]]; then
  echo "It's not considered as a release, do nothing."
  else {
    echo "It's a release, so we'll publish it."
    echo $GITHUB_CREDENTIALS_PSW | gh auth login --with-token
    gh release create v$versionName --generate-notes $GH_OPTS ./app/build/outputs/apk/**/*apk
    # Now let's tackle with the Google Play Store
    publishOnPlayStore
} fi