pipeline {
    agent any

    tools {
        jdk 'jdk21'
        maven 'maven3'
    }

    environment {
        NEXUS_URL        = 'http://13.206.208.132:8081'
        NEXUS_REPOSITORY = 'maven-releases'
        GROUP_ID         = 'com/example'
        ARTIFACT_ID      = 'shopping-cart'
        VERSION          = "1.0.${BUILD_NUMBER}"
    }

    stages {

        stage('Clone') {
            steps {
                git 'https://github.com/Hari7913/shopping-cart.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Upload to Nexus') {
            steps {

                withCredentials([usernamePassword(
                    credentialsId: 'nexus-creds',
                    usernameVariable: 'NEXUS_USER',
                    passwordVariable: 'NEXUS_PASS'
                )]) {

                    sh """
                    curl -u $NEXUS_USER:$NEXUS_PASS \
                    --upload-file target/shopping-cart-0.0.1-SNAPSHOT.war \
                    $NEXUS_URL/repository/$NEXUS_REPOSITORY/$GROUP_ID/$ARTIFACT_ID/$VERSION/$ARTIFACT_ID-$VERSION.war
                    """
                }
            }
        }
    }
}