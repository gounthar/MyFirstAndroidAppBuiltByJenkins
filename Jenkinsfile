pipeline {
    agent any
    options {
        timestamps()
    }
    stages {
        stage('Static Analysis') {
            steps {
                echo 'Run the static analysis to the code'
            }
        }
        stage('Compile') {
            steps {
                script {
                    sh 'echo "Compile the source code"'
                    sh 'chmod +x ./gradlew'
                    sh './gradlew build'
                    sh './gradlew :app:bundleDebug :app:bundleRelease'
                    sh './gradlew tasks --group publishing'
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
            }
            steps {
                script {
                    releaseAlreadyExists = sh (
                        script: 'chmod +x ./jenkins/release-already-exists.sh && ./jenkins/release-already-exists.sh',
                        returnStdout: true
                    )
                    echo "Release already exists: $releaseAlreadyExists ."
                    if (releaseAlreadyExists == 'false') {
                        echo "Found false. Existing release? ${releaseAlreadyExists}"
                    } else {
                        echo "Found something else. Existing release? (${releaseAlreadyExists})"
                    }
                }
            }
        }
    }
}