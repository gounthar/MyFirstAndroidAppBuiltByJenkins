FROM jenkins/ssh-agent:6.5.0 as ssh-agent

# ca-certificates because curl will need it later on for the Maven installation
RUN apt-get update && apt-get install -y --no-install-recommends adb build-essential ca-certificates curl file git unzip


# Install docker \
RUN curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
#RUN adduser jenkins docker


COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "bash", "/entrypoint.sh"]
