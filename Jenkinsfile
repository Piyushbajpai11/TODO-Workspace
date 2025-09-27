pipeline {
    agent any

    environment {
        DOCKER_IMAGE_BACKEND = "piyushbajpai685/mern-backend"
        DOCKER_IMAGE_FRONTEND = "piyushbajpai685/mern-frontend"
        DOCKER_TAG = "v1.0"
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Clean workspace and checkout code
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: 'main']],
                    extensions: [
                        [$class: 'CleanCheckout'],
                        [$class: 'RelativeTargetDirectory', relativeTargetDir: '.']
                    ],
                    userRemoteConfigs: [[url: 'https://github.com/Piyushbajpai11/TODO-Workspace.git']]
                ])
                
                // Verify the checkout worked
                sh 'ls -la'
                sh 'echo "Current directory structure:" && find . -maxdepth 2 -type d | sort'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'cd server && npm install'
                sh 'cd client && npm install'
            }
        }

        stage('Environment Setup') {
            steps {
                sh 'chmod +x scripts/*.sh'
                sh './scripts/setup.sh'
            }
        }

        stage('Health Check') {
            steps {
                sh './scripts/healthcheck.sh'
            }
        }

        stage('Build Docker Images') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE_BACKEND:$DOCKER_TAG ./server'
                sh 'docker build -t $DOCKER_IMAGE_FRONTEND:$DOCKER_TAG ./client'
            }
        }

        stage('Push Docker Images') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                    sh 'docker push $DOCKER_IMAGE_BACKEND:$DOCKER_TAG'
                    sh 'docker push $DOCKER_IMAGE_FRONTEND:$DOCKER_TAG'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f k8s/'
                sh 'kubectl rollout status deployment/mern-backend'
                sh 'kubectl rollout status deployment/mern-frontend'
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed! Check logs.'
        }
    }
}