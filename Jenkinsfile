pipeline {
    agent any

    tools {
        jdk 'jdk21'
        maven 'maven3'
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
}
