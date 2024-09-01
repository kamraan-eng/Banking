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



pipeline {
    agent any
    
    environment {
        MAVEN_HOME = tool name: 'maven', type: 'maven'
        IMAGE_NAME = 'financeproject'
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

        
        stage('Docker Build') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:latest .'
                sh 'docker images'
            }
        }

        stage('Run Docker Container') {
            steps {
                sh 'docker run -d --name seethis -p 7777:8081 ${IMAGE_NAME}:latest'
                sh 'docker ps'
            }
        }

        stage('Docker Push Image') {
            steps {
                sh 'docker push nkcharan/${IMAGE_NAME}:latest'
            }
        }
    }

    post {
        always {
            script {
                sh "docker stop seethis || true"
                sh "docker rm seethis || true"
                echo 'Cleaned up Docker container'
            }
        }
    }
}
