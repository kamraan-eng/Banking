pipeline{
    agent any
    environment {
        MAVEN_HOME = tool name: 'maven', type: 'maven'           
        IMAGE_NAME = 'financeproject'
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
                sh 'docker build -t financeproject .'
                sh 'docker images'
            }
        }

        stage('Docker Container running'){
            steps{
                sh 'docker run -d --name seethis -p 7777:8081 financeproject'
                sh 'docker ps '
            }
        }

        stage('Docker Login'){
            steps{
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials')]) {
                    sh "docker login -u ${USERNAME} -p ${PASSWORD} registry.hub.docker.com"
                }
            }
        }

        stage('Pushing Image to the Docker-Hub'){
            steps{
             sh "docker push nkcharan/financeproject:latest"
            }
        }   

    }
}