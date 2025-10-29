#!/bin/bash
set -eux
# Navigate to the jenkins directory
cd jenkins

# Use jenkins-plugin-cli to update the plugin.txt and update it
docker ps | grep jenkins | grep -v agent | awk '{print $1}' | xargs -I {} docker exec {} jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt --no-download --available-updates --output txt > controller/plugins.txt

# Check if the plugins.txt file has been modified
if git diff --quiet -- controller/plugins.txt; then
    # No changes
    echo "No plugins need to be updated"
else
    # Changes detected
    echo "Plugins have been updated, creating a pull request"

    # Create and checkout new branch
    git checkout -b "$1"

    # Add and commit changes
    git add controller/plugins.txt
    git commit -m "chore(jenkins): Update Jenkins plugins"

    # Push changes to GitHub
    git push -u origin "$1"

    # Create pull request using gh command
    gh pr create --title "chore(jenkins): Updates Jenkins plugins" --body "This pull request updates the Jenkins plugins listed in \`plugins.txt\`." --base "$2" --head "$1"
fi
