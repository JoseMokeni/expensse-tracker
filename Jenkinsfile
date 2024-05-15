pipeline {
    agent any
    tools {
        nodejs 'nodejs'
        dockerTool 'docker'
    }
    environment {
        SCANNER_HOME = tool 'sonarqube-server'
    }
    stages {
        stage('Checkout from Git') {
            steps {
                git branch: 'main', url: 'https://github.com/JoseMokeni/expense-tracker.git'
            }
        }
        stage("Sonarqube Analysis") {
            steps {
                withSonarQubeEnv('sonarqube-server') {
                    sh ''' 
                    $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=expense-tracker -Dsonar.projectKey=expense-tracker
                    '''
                }
            }
        }
        stage("Quality Gate") {
            steps {
                script {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage("Build") {
            steps {
                script {
                    docker.build("josemokeni/expense-tracker:${env.BUILD_NUMBER}")
                }
            }
        }
        stage("Push") {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        docker.image("josemokeni/expense-tracker:${env.BUILD_NUMBER}").push()
                        docker.image("josemokeni/expense-tracker:${env.BUILD_NUMBER}").push("latest")
                    }
                }
            }
        }

        stage("Deploy") {
            steps {
                sh "kubectl apply -f k8s/"
            }
        }
    }
}
