/* groovylint-disable CompileStatic, DuplicateStringLiteral, NestedBlockDepth */
pipeline {
    agent any

    environment {
        IMAGE_NAME = 'ebi-demo'
        IMAGE_TAG = 'latest'
    }

    stages {

        stage('Build and Push Docker Image') {
            environment {
                DOCKER_REGISTRY = 'neroxxpips'
                DOCKER_PASSWORD = credentials('docker-access-token')
                DOCKER_USERNAME = 'neroxxpips'
            }
            steps {
                sh 'docker build -t $DOCKER_REGISTRY/$IMAGE_NAME:$IMAGE_TAG .'
                sh 'echo $DOCKER_PASSWORD | docker login --username $DOCKER_USERNAME --password-stdin'
                sh 'docker push $DOCKER_REGISTRY/$IMAGE_NAME:$IMAGE_TAG'
                sh 'docker logout'
            }
        }

        stage('Deploy App to EKS') {
            environment {
                EKS_CLUSTER_NAME = 'OE-DevOps-cluster'
                AWS_REGION = 'us-east-1'
                NAMESPACE  = 'ebi-jenkins'
            }
            steps {
                withAWS(credentials: 'aws-credentials', region: 'us-east-1') {
                    script {
                        sh('aws eks update-kubeconfig --name $EKS_CLUSTER_NAME --region $AWS_REGION')
                        sh 'sed -i "s/__IMAGE_NAME__/$IMAGE_NAME/" deploy/deployment.yaml'
                        sh 'sed -i "s/__TAG__/$IMAGE_TAG/" deploy/deployment.yaml'
                        sh 'sed -i "s/name_space/$NAMESPACE/" deploy/namespace.yaml'
                        sh 'kubectl apply -f deploy/namespace.yaml'
                        sh 'kubectl apply -f deploy/deployment.yaml -f deploy/service.yaml --namespace $NAMESPACE'
                    }
                }
            }
        }
    }
}