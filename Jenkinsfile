// pipeline {
//     agent any
//     environment {
//         MAVEN_HOME = tool name: 'maven', type: 'maven'
//         IMAGE_NAME = 'financeproject'
//         DOCKERHUB_CREDENTIALS = credentials('docker-creds')
//     }
    
//     stages {
//         stage('Clone the GitHub repository') {
//             steps {
//                 git branch: 'finance', credentialsId: 'github', url: 'https://github.com/charannk007/Staragile-Finance-New.git'
//             }
//         }

//         stage('Build the Project') {
//             steps {
//                 script {
//                     echo "Maven Home: ${env.MAVEN_HOME}"
//                     sh "${MAVEN_HOME}/bin/mvn -version"
//                     sh "${MAVEN_HOME}/bin/mvn clean package"
//                 }
//             }
//         }

//         stage('Docker Build') {
//             steps {
//                 sh 'docker build -t ${IMAGE_NAME}:latest .'
//                 sh 'docker images'
//             }
//         }

//         stage('Run Docker Container') {
//             steps {
//                 sh 'docker run -d --name seethis -p 7777:8081 ${IMAGE_NAME}:latest'
//                 sh 'docker ps'
//             }
//         }

//         stage('Docker Login') {
//             steps {
//                 sh 'docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
//             }
//         }

//         stage('Docker Build Image') {
//             steps {
//                 script {
//                     // Define the Docker image name and tag
//                     def image = docker.build("${IMAGE_NAME}:latest")

//                     // Optionally, push the image to Docker Hub
//                     docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
//                         image.push('latest')
//                     }
//                 }
//             }
//         }
//     }
// }


// new one

pipeline {
    agent any
    
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('docker-creds') // Using your Docker credentials
        IMAGE_NAME = 'financeproject' // Your Docker image name
        DOCKER_HUB_REPO = 'nkcharan/financeproject' // Your Docker Hub repository
        DOCKER_TAG = 'latest' // Docker image tag
    }

    stages {
        stage('Docker Login') {
            steps {
                script {
                    docker.withRegistry('', DOCKER_HUB_CREDENTIALS) {
                        echo 'Logged in to Docker Hub'
                    }
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_HUB_REPO}:${DOCKER_TAG}")
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    sh "docker run -d --name my_container -p 8899:8081 ${DOCKER_HUB_REPO}:${DOCKER_TAG}"
                    echo 'Docker container is running on port 8899'
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', DOCKER_HUB_CREDENTIALS) {
                        docker.image("${DOCKER_HUB_REPO}:${DOCKER_TAG}").push()
                    }
                    echo 'Docker image pushed to Docker Hub'
                }
            }
        }
    }

    post {
        always {
            script {
                sh "docker stop my_container || true"
                sh "docker rm my_container || true"
                echo 'Cleaned up Docker container'
            }
        }
    }
}
