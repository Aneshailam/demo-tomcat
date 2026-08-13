pipeline {
    agent any

    stages {

        stage('Maven Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh 'mvn clean verify org.sonarsource.scanner.maven:sonar-maven-plugin:sonar -Dsonar.projectKey=hello-maven -Dsonar.projectName=hello-maven'
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('OWASP Dependency Check') {
            steps {
                withCredentials([string(credentialsId: 'nvd-api-key', variable: 'NVD_API_KEY')]) {
                    dependencyCheck(
                        additionalArguments: '--nvdApiKey $NVD_API_KEY',
                        odcInstallation: 'dependency-check'
                    )
                }
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
                sh 'docker run -d --name tomcat-container -p 8082:8080 tomcat-app'
            }
        }
    }
}
