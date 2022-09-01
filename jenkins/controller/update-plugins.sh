#!/bin/bash -x
JENKINS_HOST=admin:butler@jenkins:8080
#JENKINS_HOST=admin:butler@localhost:8080
cd jenkins/controller/
curl -sSL "http://$JENKINS_HOST/pluginManager/api/xml?depth=1&xpath=/*/*/shortName|/*/*/version&wrapper=plugins" | perl -pe 's/.*?<shortName>([\w-]+).*?<version>([^<]+)()(<\/\w+>)+/\1 \2\n/g'|sed 's/ /:/' > /tmp/jenkins_plugins.txt
sort -o /tmp/sorted_jenkins_plugins.txt /tmp/jenkins_plugins.txt
sed -i '1s/^/# See https:\/\/github.com\/jenkinsci\/docker#usage-1\n/' /tmp/sorted_jenkins_plugins.txt
diff -u ./plugins.txt /tmp/sorted_jenkins_plugins.txt > /tmp/jenkins_plugins.diff
if [ -s /tmp/jenkins_plugins.diff ]; then
    echo "Plugins have changed, updating plugins.txt"
    echo $GITHUB_CREDENTIALS_PSW | gh auth login --with-token
    cp /tmp/sorted_jenkins_plugins.txt ./plugins.txt
    git add ./plugins.txt
    # Get current branch name
    branch_name=$GIT_BRANCH
    echo "Working on branch $branch_name for repo $GIT_URL"
    new_branch_name="update-$branch_name/"$(sha1sum /tmp/jenkins_plugins.diff | cut -d " " -f1)
    git config --global user.email "116569+gounthar@users.noreply.github.com"
    git config --global user.name "$GITHUB_CREDENTIALS_USR"
    git switch -c "${new_branch_name}" -m
    git commit -m "Update plugins.txt"
    # git push --set-upstream origin "${new_branch_name}"
    git push --set-upstream https://"$GITHUB_CREDENTIALS_USR":"$GITHUB_CREDENTIALS_PSW"@github.com/gounthar/MyFirstAndroidAppBuiltByJenkins.git "${new_branch_name}"
    # Now use gh to create a pull request from new_branch_name to branch_name
    gh pr create -B "$branch_name" -t "Update plugins.txt" -b "Update plugins.txt"
    git switch "${branch_name}"
else
    echo "Plugins have not changed"
fi
