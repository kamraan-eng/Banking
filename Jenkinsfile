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
                sh 'docker build -t ${IMAGE_NAME}:v2 .'
                sh 'docker images'
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

        stage('Install Terraform') {
            steps {
                // Install Terraform if not already installed
                sh '''
                if ! [ -x "$(command -v terraform)" ]; then
                  wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
                  unzip terraform_${TF_VERSION}_linux_amd64.zip
                  sudo mv terraform /usr/local/bin/
                fi
                '''
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
    }
    post {
        success {
            echo 'Pipeline completed successfully.'
        }
    }
}
