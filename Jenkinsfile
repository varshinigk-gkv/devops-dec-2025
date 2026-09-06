pipeline {

    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Validate') {
            steps {
                sh 'test -f index.html'
                sh 'test -f Dockerfile'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t gkv9972/devops-html-app:${BUILD_NUMBER} .'
            }
        }

        stage('Push Docker Image') {
            steps {
                // Docker Hub credentials
                // docker push
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                // kubectl deployment
            }
        }

        stage('Verify') {
            steps {
                sh 'kubectl get pods'
            }
        }
    }
}
