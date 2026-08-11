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
                sh 'mvn clean package'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'sudo docker build -t tomcat-app .'
            }
        }

        stage('Docker Run') {
            steps {
                sh 'sudo docker stop tomcat-container || true'
                sh 'sudo docker rm tomcat-container || true'
                sh 'sudo docker run -d --name tomcat-container -p 8080:8080 tomcat-app'
            }
        }
    }
}
