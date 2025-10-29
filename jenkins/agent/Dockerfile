# Use quickstart-tutorials Android agent image as base
# This image is maintained at https://github.com/jenkins-docs/quickstart-tutorials
# and published to GHCR automatically (twice daily)
# Base image includes: Maven, Android SDK 33, Build Tools 30.0.3, GitHub CLI
FROM ghcr.io/jenkins-docs/jenkinsci-tutorials:android_

# Switch to root for project-specific customizations
USER root

# Install ADB keys for DeviceFarmer STF
RUN mkdir -p /home/jenkins/.android && \
    touch /home/jenkins/.android/adbkey.pub && \
    touch /home/jenkins/.android/adbkey
COPY adbkey.txt /home/jenkins/.android/adbkey
COPY adbkey.pub /home/jenkins/adbkey.pub

# Install DeviceFarmer STF script and Python dependencies
ENV DEVICEFARMER_STF_HOME=/usr/local/stf
RUN mkdir -p "${DEVICEFARMER_STF_HOME}" && \
    apt-get update && \
    apt-get install -y --no-install-recommends python3-requests && \
    rm -rf /var/lib/apt/lists/*

COPY android-stf-api.py "${DEVICEFARMER_STF_HOME}"/
RUN chmod 755 "${DEVICEFARMER_STF_HOME}"/android-stf-api.py && \
    chown -R jenkins:jenkins /home/jenkins/.android && \
    chmod 644 /home/jenkins/.android/adbkey* && \
    chmod -R 777 /home/jenkins/.android

ENV PATH=$PATH:$DEVICEFARMER_STF_HOME

# Copy gradle wrapper for this project
COPY . .
COPY gradlew "${JENKINS_AGENT_HOME}"/

# Set up Gradle home
ENV GRADLE_HOME="${JENKINS_AGENT_HOME}"/.gradle
RUN chown -R jenkins:jenkins "${JENKINS_AGENT_HOME}" && \
    chmod +x "${JENKINS_AGENT_HOME}"/gradlew

# Pre-download gradle wrapper (as jenkins user)
USER jenkins
RUN ./gradlew -d --version

# Stay as jenkins user for agent execution
