FROM jenkins/jenkins:latest-jdk17

## Disables the startup wizard
RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state

## Install custom plugins
# To update plugins: docker run --rm -v "$(pwd):$(pwd):ro" --entrypoint=jenkins-plugin-cli jenkins/jenkins:latest-jdk17 --available-updates --war /usr/share/jenkins/jenkins.war --output txt --plugin-file "$(pwd)"/plugins.txt
COPY --chown=jenkins:jenkins ./plugins.txt /usr/share/jenkins/plugins.txt
RUN jenkins-plugin-cli --plugin-file=/usr/share/jenkins/plugins.txt

