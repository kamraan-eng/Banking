pipeline {
    agent any
    
    environment {
        KUBE_CONFIG = credentials('kubeconfig') // Kubernetes config credentials
        MAVEN_HOME = tool name: 'maven', type: 'maven'
        IMAGE_NAME = 'financeproject'
        USER_NAME = 'nkcharan'
        DOCKERHUB_CREDENTIALS = credentials('docker-creds') 
        SSH_SERVER = 'kubes'
    }
    
    stages {
        stage('Clone the GitHub repository') {
            steps {
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

        stage('Docker Login') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin"
                    }
                }
            }
        }

        stage('Removing Existing Images and Container') {
            steps {
                sh 'docker rm -f $(docker ps -aq) || true'
                sh 'docker rmi -f $(docker images -q) || true'
            }
        }
        
        stage('Docker Build') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:v1 .'
                sh 'docker images'
            }
        }

        stage('Run Docker Container') {
            steps {
                sh 'docker run -d --name projectcapstone -p 7777:8081 ${IMAGE_NAME}:v1'
                sh 'docker ps'
            }
        }

        stage('Creating the Image') {
            steps {
                sh 'docker tag ${IMAGE_NAME}:v1 ${USER_NAME}/${IMAGE_NAME}:v1'
            }
        }

        stage('Docker Push Image') {
            steps {
                sh 'docker push ${USER_NAME}/${IMAGE_NAME}:v1'
            }
        }

        stage('Delete Existing Kubernetes Resources') {
            steps {
                script {
                    sshagent([SSH_SERVER]) {
                        sh 'ssh -o StrictHostKeyChecking=no kubes@kubes "kubectl delete deployment capstone-project --ignore-not-found=true"'
                        sh 'ssh -o StrictHostKeyChecking=no kubes@kubes "kubectl delete service capstoneproject-service --ignore-not-found=true"'
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sshagent([SSH_SERVER]) {
                        sh 'ssh -o StrictHostKeyChecking=no kubes@kubes "kubectl apply -f /home/kubes/capstoneproject/deployment.yaml"'
                        sh 'ssh -o StrictHostKeyChecking=no kubes@kubes "kubectl apply -f /home/kubes/capstoneproject/service.yaml"'
                    }
                }
            }
        }
    }
    
    post {
        always {
            script {
                sh "docker stop projectcapstone || true"
                sh "docker rm projectcapstone || true"
                echo 'Cleaned up Docker container'
            }
        }
    }
}
