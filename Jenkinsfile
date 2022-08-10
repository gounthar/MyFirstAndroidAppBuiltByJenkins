def getBranchName() {
   return "${GIT_BRANCH.split('/').size() > 1 ? GIT_BRANCH.split('/')[1..-1].join('/') : GIT_BRANCH}"
}
pipeline {
    environment {
        BRANCH_NAME = getBranchName()
        DOCKER_IMAGE_NAME = "gounthar/jenkinsci-docker-android-base:$BRANCH_NAME"
    }
    agent {
        docker {
            alwaysPull true
            image "gounthar/jenkinsci-docker-android-base:${BRANCH_NAME}"
            label 'ubuntu'
        }
    }
    options {
        timestamps()
    }
    stages {
        stage('Checkout') {
            steps {
                echo 'Checkout if needed'
                sh 'ls -artl /home/jenkins/.gradle/wrapper/dists'
                sh 'find / -name "*.zip" -exec ls {} \\;'
            }
        }
        stage('Static Analysis') {
            steps {
                echo 'Run the static analysis to the code'
                sh 'chmod +x ./gradlew'
                sh './gradlew check'
            }
        }
        stage('Compile') {
            environment {
                ANDROID_PUBLISHER_CREDENTIALS = credentials('android-publisher-credentials')
            }
            steps {
                script {
                    sh 'echo "Compile the source code"'
                    sh 'env | grep $HOME'
                    sh 'chmod +x ./gradlew'
                    sh './gradlew build'
                    sh 'ls -artl /home/jenkins/.gradle/wrapper/dists'
                    sh 'find /home/jenkins/ -name "gradle-7.3.3-bin.zip" -exec ls {} \\;'
                    sh './gradlew :app:bundleDebug :app:bundleRelease'
                }
            }
        }
        stage('Security Check') {
            steps {
                echo 'Run the security check against the application'
            }
        }
        stage('Run Unit Tests') {
            steps {
                echo 'Run unit tests from the source code'
            }
        }
        stage('Run Integration Tests') {
            steps {
                echo 'Run only crucial integration tests from the source code'
            }
        }
        stage('Publish Artifacts') {
            steps {
                echo 'Save the assemblies generated from the compilation'
            }
        }
        stage('Release on GitHub') {
            environment {
                GITHUB_CREDENTIALS = credentials('github-app-android')
                ANDROID_PUBLISHER_CREDENTIALS = credentials('android-publisher-credentials')
            }
            steps {
                script {
                // Later on, move everything into functions and call them here.
                     releaseAlreadyExists = sh (
                            script: 'chmod +x ./jenkins/release-already-exists.sh && bash -x ./jenkins/release-already-exists.sh',
                            returnStdout: true
                        )
                        echo "Release already exists: $releaseAlreadyExists."
                        if (releaseAlreadyExists == 'false') {
                            echo "The release does not exist yet, so we can create it."
                            createRelease()
                        } else {
                            echo "The release already exists, so we won't create it."
                        }
                }
            }
        }
        stage('Release on Google Play Store') {
            environment {
                GITHUB_CREDENTIALS = credentials('github-app-android')
                ANDROID_PUBLISHER_CREDENTIALS = credentials('android-publisher-credentials')
            }
            steps {
                echo 'Publishes the bundle on the Google Play Store'
                createGooglePlayStoreRelease()
            }
        }
    }
}

void releaseAlreadyExist(config) {
    GITHUB_CREDENTIALS_PSW = credentials('github-app-android').toString()
    echo $GITHUB_CREDENTIALS_PSW
}

void createRelease() {
    sh (
        script: 'chmod +x ./jenkins/create-release.sh && ./jenkins/create-release.sh',
        returnStdout: true
    )
}

void createGooglePlayStoreRelease() {
    sh (
        script: 'chmod +x ./jenkins/create-gps-release.sh && ./jenkins/create-gps-release.sh',
        returnStdout: true
    )
}
