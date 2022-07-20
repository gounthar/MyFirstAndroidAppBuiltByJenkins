 #!/bin/sh

versionName=$(./gradlew printVersion | grep "Version name:" | cut -d ' ' -f 3 | sed -e 's/^[[:space:]]*//')
# echo "Release version: ${versionName}"

versionCode=$(./gradlew printVersion | grep "Version code:" | grep -o '[^ ]*$' | sed -e 's/^[[:space:]]*//')
# echo "Release version code: ${versionCode}"

echo $GITHUB_CREDENTIALS_PSW | gh auth login --with-token
existingRelease=$(gh release list | grep -F $versionName)
lookAlikeExistingRelease=

[ -z "$existingRelease" ] && {
# echo "No release with version ${versionName} found"
} || {
# echo "Release $versionName already exists"
  lookAlikeExistingRelease=$(echo $existingRelease | cut -d$'\t' -f 1 | cut -c 2-)
}
# echo "Existing release for $versionName : $lookAlikeExistingRelease"

result=$([ -z "$lookAlikeExistingRelease" ] && echo "" || echo "$lookAlikeExistingRelease")
[ -z "$result" ] && echo -n "false" || echo -n "true"