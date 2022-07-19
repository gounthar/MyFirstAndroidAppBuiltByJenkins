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
                    existingRelease = '0.0.0'
                    versionName = sh 'echo $(grep versionName app/build.gradle | cut -d \'"\' -f 2)'
                    versionCode = sh 'grep versionCode app/build.gradle | grep -o \'[^ ]*$\''
                    sh 'echo $GITHUB_CREDENTIALS_PSW | gh auth login --with-token'
                    sh 'echo "$(gh release list)"'
                    sh 'echo "$(gh release list | grep ${versionName})"'
                    sh 'echo "$(gh release list | grep ${versionName} | cut -d$\'\t\' -f 1 | cut -c 2-)"'
                    existingRelease = sh 'gh release list | grep ${versionName} | cut -d$\'\t\' -f 1 | cut -c 2-'
                    echo "Existing release is ${existingRelease}"
                }
            }
        }
    }
}