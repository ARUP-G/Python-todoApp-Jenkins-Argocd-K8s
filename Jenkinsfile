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
           steps{
                withCredentials([usernamePassword(credentialsId: 'docker-cred', passwordVariable: 'DOCKER_REGISTRY_PWD', usernameVariable: 'DOCKER_REGISTRY_USER')]){
                    sh '''
                    echo 'Push to Repo'
                    docker push ard3dk/todoapp:${BUILD_NUMBER}
                    '''
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
            steps {
                script{
                    withCredentials([usernamePassword(credentialsId: 'jenkins-todo', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                        sh '''
                        cat deploy.yaml
                        sed -i '' "s/32/${BUILD_NUMBER}/g" deploy.yaml
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
