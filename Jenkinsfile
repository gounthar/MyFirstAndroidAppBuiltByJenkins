pipeline {
    agent any 
    stages {
        stage('Static Analysis') {
            steps {
                echo 'Run the static analysis to the code' 
            }
        }
        stage('Compile') {
            steps {
                echo 'Compile the source code' 
                chmod +x ./gradlew
                bash './gradlew build'
                bash 'cd app/build/outputs/apk/release && rm app-release-unsigned-aligned.apk 2> /dev/null || true'
                bash 'apksigner verify app-release.apk'
                bash 'cd - && ./gradlew :app:bundleDebug :app:bundleRelease'
                bash './gradlew tasks --group publishing'
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
    }
}
