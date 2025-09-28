pipeline {
    agent any

    environment {
        DOCKER_IMAGE_BACKEND = "piyushbajpai685/mern-backend"
        DOCKER_IMAGE_FRONTEND = "piyushbajpai685/mern-frontend"
        DOCKER_TAG = "v1.0"
    }

    stages {

        stage('Checkout') {
            steps {
                deleteDir() // ensure clean workspace
                git branch: 'main', url: 'https://github.com/Piyushbajpai11/TODO-Workspace.git'
            }
        }

        stage('Install Node.js') {
            steps {
                sh '''
                    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
                    apt-get install -y nodejs
                    node -v
                    npm -v
                '''
            }
        }

        stage('Setup Environment') {
            steps {
                sh '''
                  chmod +x scripts/setup.sh
                  ./scripts/setup.sh
                '''
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'cd server && npm install'
                sh 'cd client && npm install'
            }
        }

        stage('Run Healthcheck') {
            steps {
                sh '''
                  chmod +x scripts/healthcheck.sh
                  ./scripts/healthcheck.sh
                '''
            }
        }

        stage('Install Docker') {
            steps {
                sh '''
                  apt-get update
                  apt-get install -y apt-transport-https ca-certificates curl software-properties-common
                  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
                  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
                  apt-get update
                  apt-get install -y docker-ce docker-ce-cli containerd.io
                  docker --version
                '''
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
            }
        }

    } // stages

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed! Check logs.'
        }
    }
}
