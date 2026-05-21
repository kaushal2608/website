pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = "kaushal2608"
        IMAGE_NAME = "kaushal2608/capstone-website"
        IMAGE_TAG = "latest"
        GITHUB_REPO = "https://github.com/kaushal2608/website.git"
    }

    stages {

        stage('Git Clone') {
            steps {
                echo 'Cloning GitHub repository...'
                git branch: 'master',
                    credentialsId: 'github-credentials',
                    url: "${GITHUB_REPO}"
            }
        }

        stage('Docker Build') {
            steps {
                echo 'Building Docker image...'
                sh '''
                    docker build --no-cache -t ${IMAGE_NAME}:${IMAGE_TAG} .
                '''
            }
        }

        stage('Docker Push') {
            steps {
                echo 'Pushing Docker image to DockerHub...'
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo 'Deploying to Kubernetes cluster...'
                sh '''
                    sed -i 's|<dockerhub-username>/capstone-website:latest|kaushal2608/capstone-website:latest|g' deployment.yml

                    kubectl apply -f deployment.yml
                    kubectl apply -f service.yml

                    kubectl rollout status deployment/capstone-website --timeout=300s
                    kubectl get pods
                    kubectl get svc capstone-website-service
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
            echo 'Website deployed at http://54.234.75.50:30008'
        }

        failure {
            echo 'Pipeline failed! Check logs.'
        }
    }
}
