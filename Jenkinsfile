pipeline {
    agent any

    environment {
        MAVEN_HOME = tool name: 'maven', type: 'maven'
        IMAGE_NAME = 'financeproject'
        USER_NAME = 'nkcharan'
        DOCKERHUB_CREDENTIALS = credentials('docker-creds') // Docker credentials ID
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

        stage('Removing existing Images and Containers') {
            steps {
                script {
                    // Remove existing containers if any
                    sh """
                    CONTAINERS=\$(docker ps -aq)
                    if [ "\$CONTAINERS" ]; then
                        docker rm -f \$CONTAINERS
                    else
                        echo "No containers to remove"
                    fi
                    """

                    // Remove existing images if any
                    sh """
                    IMAGES=\$(docker images -q)
                    if [ "\$IMAGES" ]; then
                        docker rmi -f \$IMAGES
                    else
                        echo "No images to remove"
                    fi
                    """
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:v2 .'
                sh 'docker images'
            }
        }

        stage('Run Docker Container') {
            steps {
                sh 'docker run -d --name projectcapstone -p 7777:8081 ${IMAGE_NAME}:v2'
                sh 'docker ps'
            }
        }

        stage('Creating the Image') {
            steps {
                sh 'docker tag ${IMAGE_NAME}:v2 ${USER_NAME}/${IMAGE_NAME}:v2'
            }
        }

        stage('Docker Push Image') {
            steps {
                sh 'docker push ${USER_NAME}/${IMAGE_NAME}:v2'
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
