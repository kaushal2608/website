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
                echo 'Cloning latest GitHub code...'
                deleteDir()
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/master']],
                    userRemoteConfigs: [[
                        url: "${GITHUB_REPO}",
                        credentialsId: 'github-credentials'
                    ]]
                ])
            }
        }

        stage('Docker Build') {
            steps {
                echo 'Building fresh Docker image...'
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
                    kubectl apply -f deployment.yml
                    kubectl apply -f service.yml

                    kubectl rollout restart deployment capstone-website
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
            echo 'Website deployed successfully!'
        }

        failure {
            echo 'Pipeline failed! Check logs.'
        }
    }
}
