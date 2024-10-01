pipeline {
    agent any

    environment {
        MAVEN_HOME = tool name: 'maven', type: 'maven'
        IMAGE_NAME = 'financeproject'
        USER_NAME = 'nkcharan'
        DOCKERHUB_CREDENTIALS = credentials('docker-creds') 
        AWS_ACCESS_KEY_ID = credentials('Access-key')
        AWS_SECRET_ACCESS_KEY = credentials('Secret-access-key')
        TF_VERSION = "1.3.0"
        ANSIBLE_USER = 'ansuser'
        ANSIBLE_PASSWORD = '12345678'

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
                sh 'docker build -t ${IMAGE_NAME}:v3 .'
                sh 'docker images'
            }
        }

        stage('Creating the Image') {
            steps {
                sh 'docker tag ${IMAGE_NAME}:v3 ${USER_NAME}/${IMAGE_NAME}:v3'
            }
        }

        stage('Docker Push Image') {
            steps {
                sh 'docker push ${USER_NAME}/${IMAGE_NAME}:v3'
            }
        }

        stage('Terraform Init') {
            steps {
                // Initialize Terraform configuration files
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                // Plan the infrastructure deployment
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                // Apply the infrastructure configuration
                sh 'terraform apply -auto-approve tfplan'
            }
        }

         stage('Using Ansible') {
            steps {
                script {
                    // Change user and run the ansible playbook with sudo, passing password
                    sh """
                    echo ${ANSIBLE_PASSWORD} | sudo -S su - ${ANSIBLE_USER} -c '
                        ansible-playbook  ansible-playbook.yml
                    '
                    """
                }
            }
        }
    }
    post {
        success {
            echo 'Pipeline completed successfully.'
        }
    }
}
