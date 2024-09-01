pipeline{
    agent any
    environment {
        MAVEN_HOME = tool name: 'maven', type: 'maven'           
        IMAGE_NAME = 'financeproject'
        DOCKERHUB_CREDENTIALS = credentials('docker-creds')
    }
    
    stages{
        stage('Clone the Github repository'){
            steps{
            git branch: 'finance', credentialsId: 'github', url: 'https://github.com/charannk007/Staragile-Finance-New.git'
            }
        }

        stage('Build the Project') {
            steps {
                script {
                    echo "Maven Home: ${env.MAVEN_HOME}"
                    sh "${MAVEN_HOME}/bin/mvn -version" 
                    sh "${MAVEN_HOME}/bin/mvn clean package" 
                }
            }
        }

          stage('Docker build'){
            steps{
                sh 'docker build -t financeproject:latest .'
                sh 'docker images'
            }
        }

        stage('Docker Container running'){
            steps{
                sh 'docker run -d --name seethis -p 7777:8081 financeproject:latest'
                sh 'docker ps '
            }
        }

        stage('Docker Login'){

             steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                        echo 'Logged in to Docker Hub successfully'
                    }
                }
            }
        }

        stage('Docker build Image'){
             script {
                    // Define the Docker image name and tag
                    def image = docker.build("financeproject:latest")

                    // Optionally, push the image to Docker Hub
                    docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                        image.push('latest')
                    }
                }
        }
    }
}
