pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Maven Build') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t tomcat-app .'
            }
        }

        stage('Docker Run') {
            steps {
                sh 'docker stop tomcat-container || true'
                sh 'docker rm tomcat-container || true'
                sh 'docker run -d --name tomcat-container -p 8080:8080 tomcat-app'
            }
        }
    }
}
