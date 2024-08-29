pipeline{
    agent any
    environment {
        MAVEN_HOME = tool name: 'maven', type: 'maven'
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
                    sh "${MAVEN_HOME}/bin/mvn -version" // Check Maven version
                    sh "${MAVEN_HOME}/bin/mvn clean package" // Run Maven build
                }
            }
        }


    }
}
