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

suffix=$(echo $versionName | sed 's/.*-//')
case $suffix in
    ALPHA|BETA)
        echo "Time to do a prerelease"
        GH_OPTS="$GH_OPTS-p"
        ;;
    SNAPSHOT)
        echo "This is a snapshot, we won't release anything";;
    RELEASE)
        echo "This a real release, so no need to use -d or -p";;
    *)
        echo "Unknown suffix \"$suffix\", so we'll do a draft release"
        GH_OPTS="$GH_OPTS-d"
        ;;
esac
echo "gh release create v$versionName --generate-notes $GH_OPTS ./app/build/outputs/apk/**/*apk"
