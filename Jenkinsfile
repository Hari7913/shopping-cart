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

        DOCKER_IMAGE     = 'lucky7913/shopping-cart'

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

            sh '''
            curl -v -u ${NEXUS_USER}:${NEXUS_PASS} \
            --upload-file target/shopping-cart-0.0.1-SNAPSHOT.war \
            http://13.206.208.132:8081/repository/maven-releases/com/example/shopping-cart/1.0.${BUILD_NUMBER}/shopping-cart-1.0.${BUILD_NUMBER}.war
            '''
        }
    }
}
    stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} .
                docker tag ${DOCKER_IMAGE}:${BUILD_NUMBER} ${DOCKER_IMAGE}:latest
                '''
            }
        }

        stage('Push Docker Image') {
            steps {

                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {

                    sh '''
                    echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin
                    docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}
                    docker push ${DOCKER_IMAGE}:latest
                    docker logout
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
    steps {
        sh '''
        aws eks update-kubeconfig --region ap-south-1 --name shopping-cluster

        sed -i "s|IMAGE_NAME|lucky7913/shopping-cart:${BUILD_NUMBER}|g" k8s/deployment.yml

        kubectl apply -f k8s/deployment.yml --validate=false
        kubectl apply -f k8s/service.yml --validate=false
        '''
    }
}
    }
}