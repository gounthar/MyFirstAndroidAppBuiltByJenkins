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
                script {
                    echo 'Compile the source code' 
                    chmod +x ./gradlew
                    echo "Test to see if the gradlew is the main cause of the failure"
                    echo "./gradlew build"
                    cd app/build/outputs/apk/release && rm app-release-unsigned-aligned.apk 2> /dev/null || true
                    apksigner verify app-release.apk
                    cd - && ./gradlew :app:bundleDebug :app:bundleRelease
                    ./gradlew tasks --group publishing
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
    }
}
