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
                        additionalArguments: "--nvdApiKey ${NVD_API_KEY} --format HTML",
                        odcInstallation: 'dependency-check'
                    )
                }
            }
        }

        stage('Publish OWASP Report') {
            steps {
                publishHTML([
                    allowMissing: true,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: '.',
                    reportFiles: 'dependency-check-report.html',
                    reportName: 'OWASP Dependency Check Report',
                    reportTitles: 'OWASP Dependency Check'
                ])
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t tomcat-app .'
            }
        }

        stage('Trivy Security Scan') {
            steps {
                sh 'trivy image --severity HIGH,CRITICAL tomcat-app:latest'
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
