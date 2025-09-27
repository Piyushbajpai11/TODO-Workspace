pipeline {
    agent any

    environment {
        DOCKER_IMAGE_BACKEND = "your-dockerhub-username/mern-backend"
        DOCKER_IMAGE_FRONTEND = "your-dockerhub-username/mern-frontend"
        DOCKER_TAG = "v1.0"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/chetannada/MERN-Todo.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'cd backend && npm install'
                sh 'cd frontend && npm install'
            }
        }

        stage('Run Shell Scripts') {
            steps {
                sh './scripts/setup.sh'
                sh './scripts/healthcheck.sh'
            }
        }

        stage('Build Docker Images') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE_BACKEND:$DOCKER_TAG ./backend'
                sh 'docker build -t $DOCKER_IMAGE_FRONTEND:$DOCKER_TAG ./frontend'
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
