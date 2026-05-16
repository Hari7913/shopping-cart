pipeline {
    agent any

    tools {
        jdk 'jdk21'
        maven 'maven3'
    }

    environment {
        NEXUS_URL = 'http://65.2.191.60:8081'
        NEXUS_REPOSITORY = 'maven-releases'
        GROUP_ID = 'com.example'
        ARTIFACT_ID = 'shopping-cart'
        VERSION = '1.0.${BUILD_NUMBER}'
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
                    mvn deploy:deploy-file \
                    -DgroupId=${GROUP_ID} \
                    -DartifactId=${ARTIFACT_ID} \
                    -Dversion=${VERSION} \
                    -Dpackaging=jar \
                    -Dfile=target/${ARTIFACT_ID}-0.0.1-SNAPSHOT.jar \
                    -DrepositoryId=nexus \
                    -Durl=${NEXUS_URL}/repository/${NEXUS_REPOSITORY}/ \
                    -DgeneratePom=true \
                    -Dusername=${NEXUS_USER} \
                    -Dpassword=${NEXUS_PASS}
                    """
                }
            }
        }
    }
}
