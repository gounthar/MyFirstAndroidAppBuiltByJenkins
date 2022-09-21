def getBranchName() {
   return "${GIT_BRANCH.split('/').size() > 1 ? GIT_BRANCH.split('/')[1..-1].join('/') : GIT_BRANCH}"
}

def getSimplifiedBranchName() {
   return "${getBranchName().replace('/', '-')}"
}

pipeline {
    environment {
        BRANCH_NAME = getSimplifiedBranchName() // getBranchName()
        DOCKER_IMAGE_NAME = "gounthar/jenkinsci-docker-android-base:$BRANCH_NAME"
    }
    agent any
    options {
        timestamps()
    }
    stages {
//        stage('Checkout') {
//            agent any
//            steps {
//                echo 'Checkout if needed'
//            }
//        }
        stage('Static Analysis') {
            parallel {
                stage('Static Analysis with gradlew check') {
                    agent {
                        label 'android'
                    }
                    steps {
                        echo 'Run the static analysis to the code'
                        sh 'chmod +x ./gradlew'
                        sh './gradlew detekt --auto-correct'
                        sh 'git diff'
                        sh './gradlew check'
                    }
                }
                stage('Qodana') {
                    agent {
                        label 'docker'
                    }
                    steps {
                        sh 'docker build --tag=qodana-build-1 --file=jenkins/qodana/Dockerfile --progress=plain --output qodana-results .'
                        archiveArtifacts artifacts: 'qodana-results/**', allowEmptyArchive: true
                    }
                }
            }
        }
        stage('Compile and Code Coverage') {
            parallel {
                stage('Compile') {
                    environment {
                        ANDROID_PUBLISHER_CREDENTIALS = credentials('android-publisher-credentials')
                    }
                    agent {
                        label 'android'
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
                stage('Code Coverage') {
                    environment {
                        ANDROID_PUBLISHER_CREDENTIALS = credentials('android-publisher-credentials')
                    }
                    agent {
                        label 'android'
                    }
                    steps {
                        script {
                            sh 'echo "Ensure that the code coverage is not just wishful thinking"'
                            sh 'chmod +x ./gradlew'
                            sh 'chmod +x ./gradlew && ./gradlew jacocoTestReport'
                            sh 'find build -name "*eports*"'
                        }
                    }
                }
            }
        }
        stage('Security Check') {
            agent any
            steps {
                echo 'Run the security check against the application'
                echo 'Something like dependency check or dependabot'
            }
        }
        stage('Run Unit Tests') {
            agent {
                label 'android'
            }
            steps {
                echo 'Run unit tests from the source code'
                sh 'chmod +x gradlew && ./gradlew test'
            }
        }
        stage('Run Instrumented Tests') {
            agent {
                label 'android'
            }
            steps {
                lock('MyEmulator') {
                    echo 'Run only instrumented tests from the source code'
                    // We don't have any device connected yet
                    sh 'adb connect emulator:5555'
                    sh 'adb connect second-emulator:5557'
                    sh 'adb devices'
                    sh 'adb -s emulator:5555 wait-for-device shell \'while [[ -z $(getprop sys.boot_completed) ]]; do sleep 1; done;\''
                    sh 'adb -s emulator:5555 shell am start -n "io.jenkins.mobile.example.myfirstbuiltbyjenkinsapplication/io.jenkins.mobile.example.myfirstbuiltbyjenkinsapplication.MainActivity" -a android.intent.action.MAIN -c android.intent.category.LAUNCHER'
                    sh 'adb devices'
                    sh 'chmod +x ./gradlew &&./gradlew connectedAndroidTest'
                }
            }
        }
        stage('Publishing Artifacts on Jenkins/GitHub/GooglePlayStore') {
            parallel {
                stage('Publish Artifacts') {
                    agent any
                    steps {
                        echo 'Save the assemblies generated from the compilation'
                        archiveArtifacts artifacts: 'app/build/outputs/apk/**/*.apk', allowEmptyArchive: true
                        archiveArtifacts artifacts: 'app/build/outputs/bundle/**/*.aab', allowEmptyArchive: true
                        archiveArtifacts artifacts: 'app/build/reports/*xml', allowEmptyArchive: true
                        archiveArtifacts artifacts: 'app/build/reports/*html', allowEmptyArchive: true
                        archiveArtifacts artifacts: 'app/build/reports/**/*.xml', allowEmptyArchive: true
                        archiveArtifacts artifacts: 'app/build/reports/**/*.html', allowEmptyArchive: true
                        archiveArtifacts artifacts: 'app/build/outputs/androidTest-results/connected/*.pb', allowEmptyArchive: true
                        publishHTML([allowMissing: true, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'app/build/reports', reportFiles: 'lint-results-debug.html', reportName: 'Lint Report', reportTitles: ''])
                        publishHTML([allowMissing: true, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'app/build/reports/detekt', reportFiles: 'detekt.html', reportName: 'Detekt Report', reportTitles: ''])
                        publishHTML([allowMissing: true, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'app/build/reports/spotbugs', reportFiles: 'debug.html', reportName: 'Spotbugs Debug Report', reportTitles: ''])
                        publishHTML([allowMissing: true, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'app/build/reports/spotbugs', reportFiles: 'release.html', reportName: 'Spotbugs Release Report', reportTitles: ''])
                        publishHTML([allowMissing: true, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'app/build/reports/tests/testDebugUnitTest', reportFiles: 'index.html', reportName: 'Test Debug Unit Testing Report', reportTitles: ''])
                        publishHTML([allowMissing: true, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'app/build/reports/tests/testReleaseUnitTest', reportFiles: 'index.html', reportName: 'Test Release Unit Testing', reportTitles: ''])
                    }
                }
                stage('Invoke Pipeline PublishAppToGitHubAndGoogle') {
                    steps {
                        build job: 'PublishAppToGitHubAndGoogle', parameters: [], propagate: true, wait: false
                    }
                }
            }
        }
    }
//     post {
//         always {
// //             junit '/app/build/jacoco/*.xml'
// //             junit '/app/build/test-results/**/*.xml'
// //             junit '/app/build/reports/tests/*.xml'
// //             junit '/app/build/reports/*.xml'
// //             junit '/app/build/reports/detekt/*.xml'
// //             junit '/app/build/reports/spotbugs/*.xml'
// 	        testResultsAggregator jobs:[[jobName: 'My CI Job1'], [jobName: 'My CI Job2'], [jobName: 'My CI Job3']]
//         }
//     }
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

// testResultsAggregator columns: 'Job, Build, Status, Percentage, Total, Pass, Fail',
//                       recipientsList: 'nick@some.com,mairy@some.com',
//                       outOfDateResults: '10',
//                       sortresults: 'Job Name',
//                       subject: 'Test Results'
//                     	 jobs: [
//                             // Group with 2 Jobs
//                             [jobName: 'My CI Job1', jobFriendlyName: 'Job 1', groupName: 'TeamA'],
//                             [jobName: 'My CI Job2', jobFriendlyName: 'Job 2', groupName: 'TeamA'],
//                             // jobFriendlyName is optional
//                             [jobName: 'My CI Job3', groupName: 'TeamB'],
//                             [jobName: 'My CI Job4', groupName: 'TeamB'],
//                             // No Groups, groupName is optional
//                             [jobName: 'My CI Job6'],
//                             [jobName: 'My CI Job7']
//                         ]

