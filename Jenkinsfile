```groovy
pipeline {

    agent any

    environment {
        DOCKER_IMAGE = "gkv9972/devops-html-app"
        DOCKER_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Validate') {
            steps {
                sh '''
                    echo "Checking required files..."

                    test -f index.html
                    test -f Dockerfile
                    test -f deployment.yaml

                    echo "All required files are present."
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    echo "Building Docker image..."

                    docker build \
                        -t ${DOCKER_IMAGE}:${DOCKER_TAG} .

                    echo "Docker image built successfully."
                '''
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    sh '''
                        echo "$DOCKER_PASSWORD" | docker login \
                            -u "$DOCKER_USERNAME" \
                            --password-stdin
                    '''
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh '''
                    echo "Pushing Docker image to Docker Hub..."

                    docker push ${DOCKER_IMAGE}:${DOCKER_TAG}

                    echo "Docker image pushed successfully."
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    echo "Deploying application to Kubernetes..."

                    kubectl apply -f deployment.yaml

                    echo "Kubernetes deployment completed."
                '''
            }
        }

        stage('Verify') {
            steps {
                sh '''
                    echo "Checking Kubernetes resources..."

                    kubectl get deployments
                    kubectl get pods
                    kubectl get services

                    echo "Deployment verification completed."
                '''
            }
        }
    }

    post {

        success {
            echo "========================================"
            echo "Pipeline completed successfully!"
            echo "Docker Image: ${DOCKER_IMAGE}:${DOCKER_TAG}"
            echo "========================================"
        }

        failure {
            echo "========================================"
            echo "Pipeline failed!"
            echo "Check the console output for details."
            echo "========================================"
        }

        always {
            sh 'docker logout || true'
        }
    }
}
```

