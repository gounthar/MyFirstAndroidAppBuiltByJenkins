FROM debian:latest as ssh-agent

ARG user=jenkins
ARG group=jenkins
ARG uid=1002
ARG gid=1002

# Jenkins user should be the second one in the system, so ... 1002
RUN groupadd -g ${gid} ${group}
RUN useradd -c "Jenkins user" -d /home/${user} -u ${uid} -g ${gid} -m ${user}

ARG AGENT_WORKDIR=/home/${user}/agent

# JDK 17 is supported, so let's move to that
RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y --no-install-recommends adb build-essential curl file git unzip openjdk-17-jdk-headless

ENV JAVA_HOME /usr/lib/jvm/java-17-openjdk-amd64

# Now time to install Maven
ARG MAVEN_VERSION=3.8.1
RUN curl -sS -L -O --output-dir /tmp/ --create-dirs  https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && tar xzf "/tmp/apache-maven-${MAVEN_VERSION}-bin.tar.gz" -C /opt/ \
    && rm "/tmp/apache-maven-${MAVEN_VERSION}-bin.tar.gz" \
    && ln -s /opt/apache-maven-${MAVEN_VERSION} /opt/maven \
    && mkdir -p /etc/profile.d \
    && echo "export JAVA_HOME=$JAVA_HOME \n \
             export M2_HOME=/opt/maven \n \
             export PATH=${M2_HOME}/bin:${PATH}" > /etc/profile.d/maven.sh
ENV M2_HOME="/opt/maven"
ENV PATH="${M2_HOME}/bin/:${PATH}"

# Install Android SDK
# See https://stackoverflow.com/questions/60440509/android-command-line-tools-sdkmanager-always-shows-warning-could-not-create-se
ENV ANDROID_HOME /usr/local/android-sdk-linux
# > SDK location not found. Define location with an ANDROID_SDK_ROOT environment variable or by setting the sdk.dir path in your project's local properties file at '/home/jenkins/workspace/First Android Job/local.properties'.
ENV ANDROID_SDK_ROOT /usr/local/android-sdk-linux
ENV CMDLINE_TOOLS_HOME $ANDROID_HOME/cmdline-tools
ENV PATH /usr/local/bin:$PATH:CMDLINE_TOOLS_HOME/tools/bin
ARG ANDROID_BUILD_TOOLS_VERSION=30.0.3

RUN mkdir -p /usr/local/android-sdk-linux/cmdline-tools/latest && cd /usr/local/android-sdk-linux && \
 curl -L -O  https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip && \
 unzip -qq commandlinetools-linux-8512546_latest.zip -d tmp && mv tmp/cmdline-tools/* cmdline-tools/latest && \
 rm -rf /usr/local/android-sdk-linux/commandlinetools-linux-8512546_latest.zip && \
 yes|/usr/local/android-sdk-linux/cmdline-tools/latest/bin/sdkmanager --licenses && \
 /usr/local/android-sdk-linux/cmdline-tools/latest/bin/sdkmanager --update && \
 /usr/local/android-sdk-linux/cmdline-tools/latest/bin/sdkmanager --list && \
 /usr/local/android-sdk-linux/cmdline-tools/latest/bin/sdkmanager "platform-tools" \
                                                      "ndk;21.4.7075529" \
                                                      "extras;google;m2repository" \
                                                      "extras;android;m2repository" \
                                                      "platforms;android-32" \
                                                      "emulator" \
                                                      "build-tools;$ANDROID_BUILD_TOOLS_VERSION" \
                                                      "add-ons;addon-google_apis-google-24" \
                                                      "add-ons;addon-google_apis-google-23" 2>&1 >/dev/null && \
# groupadd -r jenkins && useradd -m -d /home/jenkins/ -s /bin/bash --no-log-init -r -g jenkins jenkins && \
 chown -R jenkins:jenkins $ANDROID_HOME && ls -artl /usr/local/android-sdk-linux
ENV PATH /usr/local/android-sdk-linux/build-tools/$ANDROID_BUILD_TOOLS_VERSION/:$PATH
ENV HOME /home/jenkins

# Install GitHub command line tool
# ENV GITHUB_TOKEN $GITHUB_TOKEN
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt update && apt install -y --no-install-recommends gh

# Install docker \
RUN curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh

RUN mkdir /home/${user}/.jenkins && mkdir -p ${AGENT_WORKDIR} && mkdir -p /home/${user}/gradle/wrapper && \
    mkdir -p /home/${user}/.gradle/wrapper/dists

# Let's try to download the gradle wrapper binary
WORKDIR /home/${user}
COPY . .
COPY gradlew /home/${user}/

ENV GRADLE_HOME=/home/${user}/.gradle

RUN chown -R ${user}:${group} /home/${user} && chmod +x /home/${user}/gradlew
USER ${user}
RUN cd /home/${user} && ./gradlew -d --version && ls -artl /home/${user}/.gradle/wrapper/dists
COPY . .
COPY gradlew /home/${user}/

# RUN find / -name "gradle-7.3.3-bin.zip" -exec ls {} \;

USER ${user}
ENV AGENT_WORKDIR=${AGENT_WORKDIR}

VOLUME /home/${user}/.jenkins
VOLUME ${AGENT_WORKDIR}
WORKDIR /home/${user}