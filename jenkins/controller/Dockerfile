FROM jenkins/jenkins:2.452

## Disables the startup wizard
RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state

## Install custom plugins
# To update plugins: docker run --rm -v "$(pwd):$(pwd):ro" --entrypoint=jenkins-plugin-cli jenkins/jenkins:latest-jdk17 --available-updates --war /usr/share/jenkins/jenkins.war --output txt --plugin-file "$(pwd)"/plugins.txt
COPY --chown=jenkins:jenkins ./plugins.txt /usr/share/jenkins/plugins.txt
RUN jenkins-plugin-cli --plugin-file=/usr/share/jenkins/plugins.txt

# Poor man's Jcasc
COPY --chown=jenkins:jenkins ./FirstJob /usr/share/jenkins/ref/jobs/FirstJob
COPY --chown=jenkins:jenkins ./MultiBranchAndroidPipeline /usr/share/jenkins/ref/jobs/MultiBranchAndroidPipeline
COPY --chown=jenkins:jenkins ./AutoUpdaterMultiBranches /usr/share/jenkins/ref/jobs/AutoUpdaterMultiBranches
COPY --chown=jenkins:jenkins ./PublishAppToGitHubAndGoogle /usr/share/jenkins/ref/jobs/PublishAppToGitHubAndGoogle

# because of /var/jenkins_home/.ssh/known_hosts [SSH] No Known Hosts file was found at /var/jenkins_home/.ssh/known_hosts. Please ensure one is created at this path and that Jenkins can read it.
RUN mkdir -p /var/jenkins_home/.ssh/ && touch /var/jenkins_home/.ssh/known_hosts && chown -R jenkins:jenkins /var/jenkins_home/.ssh/
