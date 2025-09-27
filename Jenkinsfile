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
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: 'main']],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [],
                    submoduleCfg: [],
                    userRemoteConfigs: [[url: 'https://github.com/Piyushbajpai11/TODO-Workspace.git']]
                ])
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'cd server && npm install'
                sh 'cd client && npm install'
            }
        }

        stage('Run Shell Scripts') {
            steps {
                sh 'chmod +x scripts/*.sh'
                sh './scripts/setup.sh'
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