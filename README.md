# My First Android App Built by Jenkins
Let's try an empty Android App just to see how to build it with Jenkins.

## How to run Jenkins to build the app

### A self contained Jenkins server

This repo contains the source code for the Android application, but also the configuration files to get an up and 
running Jenkins controller and agents able to build this app.
It's not mandatory to use my Jenkins configuration, you can use any other configuration, but I thought it would be a
good idea to have a specific Jenkins instance for this project. This way, you won't have to change the configuration of
your instance, to create new agents, new jobs, and so on.

If you have a look at the [`Jenkinsfile`](/Jenkinsfile) file, you will see that it uses `docker` agents, and agents
labelled `android`. These `android` agents use the docker image built for this project thanks to the 
[`Dockerfile`](/Dockerfile) file. If you don't want to build it by yourself, you can also use the
 [image](https://hub.docker.com/repository/docker/gounthar/jenkinsci-docker-android-base) that I provide.

### Prerequisites
To get this to work, you're supposed to have a `.env` file with the following content:

```bash
GITHUB_APP_ID=<your_github_app_id>
ANDROID_PUBLISHER_CREDENTIALS='<your_android_publisher_credentials>'
GITHUB_APP_KEY='<github_app_key>'
ADB_KEY='<your_adb_key>'
```
You can get `<your_github_app_id>` and `'<github_app_key>'` after applying what's explained in the
[Github App settings](https://github.com/jenkinsci/github-branch-source-plugin/blob/master/docs/github-app.adoc).

`'<your_android_publisher_credentials>'` will be found after following this
[tutorial](https://github.com/Triple-T/gradle-play-publisher#quickstart-guide).

`'<your_adb_key>'` will be found in your home directory, in `.android/adbkey` (if you have ever installed and used
Android Studio, you should have this file).

You are also supposed to modify the `jenkins/controller/MultiBranchAndroidPipeline/branches/main/config.xml` file so
that it points to the right repository (your fork). If you don't have a fork, you don't have to change anything.

Change the references to `https://github.com/gounthar/MyFirstAndroidAppBuiltByJenkins.git` by your fork.

### Launching on Linux and MacOS
You can try this at home *easily* by using `docker compose up -d --build --force-recreate` once you are in the `jenkins`
folder. 
This will launch a Jenkins server and agents on your local machine on ports 8080 and 50000.
This has been tested on `MacOs X86_64`, `MacOs aarch64 (M1)` and `Ubuntu 22.04`.

### Launching on Windows
When using Windows, you may have to use `docker-compose up -d --build --force-recreate` instead.
This will launch a Jenkins server and agents on your local machine on ports 8080 and 50000.
This has been tested on `Windows 11`.

### Launching thanks to Vagrant
Due to the base box, you have to use VirtualBox provider on Windows. I haven't tested on other OSes.
` vagrant up --provider=virtualbox --provision` will launch the Jenkins server and the agents, starting from the main
folder.
This will launch a Jenkins server and agents on your local machine on ports 8081 and 50000.
This has been tested on `Vagrant 2.3.0`.

### Launching via Gitpod
This is a work in progress for GitPod (the `Jenkins` agent using DonD does not work yet). You can try it anyway thanks
to the Gitpod button if you have installed the extension, or via this link:
[try this repo with gitpod](https://gitpod.io/#https://github.com/gounthar/MyFirstAndroidAppBuiltByJenkins).
One part of the pipeline won't work though, because it's using DonD, and I haven't found a way to use it with Gitpod.

## How to build the app 
Once logged in (`admin`/`butler`) go into _Dashboard_ `>` _MultiBranchAndroidPipeline_ `>` _branches_ `>` _main_ and
click on Build now.
If you got your credentials right, you should see the build started.
