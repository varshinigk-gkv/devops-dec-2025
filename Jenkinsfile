pipeline {


agent any

environment {
    DOCKER_IMAGE = "gkv9972/devops-html-app"
    DOCKER_TAG = "${BUILD_NUMBER}"
    KUBECONFIG = "/var/lib/jenkins/.kube/config"
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
                test -f k3s/deployment.yaml

                echo "All required files are present."
            '''
        }
    }

    stage('Build Docker Image') {
        steps {
            sh '''
                echo "Building Docker image..."

                docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .

                echo "Docker image built successfully."
            '''
        }
    }

    stage('Login to Docker Hub') {
        steps {
            withCredentials([
                usernamePassword(
                    credentialsId: 'dockerhub-credential',
                    usernameVariable: 'DOCKER_USERNAME',
                    passwordVariable: 'DOCKER_PASSWORD'
                )
            ]) {
                sh '''
                    echo "$DOCKER_PASSWORD" | docker login \
                        -u "$DOCKER_USERNAME" \
                        --password-stdin

                    echo "Docker Hub login successful."
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

    stage('Check Kubernetes Access') {
        steps {
            sh '''
                echo "Checking Kubernetes access..."

                kubectl get nodes

                echo "Kubernetes access is working."
            '''
        }
    }

    stage('Deploy to Kubernetes') {
        steps {
            sh '''
                echo "Deploying application to Kubernetes..."

                kubectl apply -f k3s/deployment.yaml

                echo "Updating deployment image..."

                kubectl set image deployment/html-app \
                    html-app=${DOCKER_IMAGE}:${DOCKER_TAG}

                echo "Waiting for deployment rollout..."

                kubectl rollout status deployment/html-app

                echo "Kubernetes deployment completed successfully."
            '''
        }
    }

    stage('Verify') {
        steps {
            sh '''
                echo "========================================"
                echo "KUBERNETES DEPLOYMENT VERIFICATION"
                echo "========================================"

                echo "Deployments:"
                kubectl get deployments

                echo ""
                echo "Pods:"
                kubectl get pods -o wide

                echo ""
                echo "Services:"
                kubectl get services

                echo ""
                echo "Deployment image:"
                kubectl get deployment html-app \
                    -o jsonpath='{.spec.template.spec.containers[0].image}'

                echo ""
                echo "========================================"
                echo "Verification completed."
                echo "========================================"
            '''
        }
    }
}

post {

    success {
        echo "========================================"
        echo "PIPELINE COMPLETED SUCCESSFULLY"
        echo "========================================"
        echo "Docker Image: ${DOCKER_IMAGE}:${DOCKER_TAG}"
        echo "Kubernetes Deployment: html-app"
        echo "========================================"
    }

    failure {
        echo "========================================"
        echo "PIPELINE FAILED"
        echo "========================================"
        echo "Check the failed stage in the console output."
        echo "========================================"
    }

    always {
        sh 'docker logout || true'
    }
}


}
