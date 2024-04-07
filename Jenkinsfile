pipeline {
    
    agent any 
    
    environment {
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        
        stage('Checkout'){
           steps {
                git credentialsId: 'jenkins-todo', 
                url: 'https://github.com/ARUP-G/Python-todoApp-Jenkins-Argocd-K8s',
                branch: 'main'
           }
        }

        stage('Build Docker'){
            steps{
                script{
                    sh '''
                    echo 'Build Docker Image'
                    docker build -t ard3dk/todoapp:${BUILD_NUMBER} .
                    '''
                }
            }
        }

        stage('Push the artifacts'){
           environment {
                DOCKER_IMAGE = "ard3dk/todoapp:${BUILD_NUMBER}"
                REGISTRY_CREDENTIALS = credentials('docker-cred')
            }
            steps{
                script{
                    def dockerImage = docker.image("${DOCKER_IMAGE}")
                    docker.withRegistry('https://index.docker.io/v1/', "docker-cred"){
                        dockerImage.push()
                    }
                }
            }
        }
        
        stage('Checkout K8S manifest SCM'){
            steps {
                git credentialsId: 'jenkins-todo', 
                url: 'https://github.com/ARUP-G/Todo-app-deployment-manifest',
                branch: 'main'
            }
        }
        
        stage('Update K8S manifest & push to Repo'){
            environment {
                    GIT_REPO_NAME = "Todo-app-deployment-manifest"
                    GIT_USER_NAME = "ARUP-G"
                    }
            steps {
                script{
                    withCredentials([string(credentialsId: 'jenkins-todo', variable: 'GITHUB_TOKEN')]) {
                        sh '''
                        cd deploy
                        cat deploy.yaml
                        sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" deploy.yaml
                        cat deploy.yaml
                        git add deploy.yaml
                        git commit -m 'Updated the deploy yaml | Jenkins Pipeline'
                        git remote -v
                        git push https://github.com/ARUP-G/Todo-app-deployment-manifest-repo.git HEAD:main
                        '''                        
                    }
                }
            }
        }
    }
}
