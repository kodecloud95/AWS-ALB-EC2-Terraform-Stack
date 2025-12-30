pipeline {
    agent any
    parameters{
        choice(name: 'operation', choices: ['Deploy', 'Destroy'], description: 'Choose to Deploy or Destroy Infrastructure')
    }
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_CREDENTIAL')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_CREDENTIAL')
        AWS_REGION = 'us-east-1'
    }

    stages {
        stage('Initiate') {
            steps {
                echo 'Terraform Initialize..'
                // Add your build steps here
                dir ("terraform") {
                    sh "terraform init"
                }
            }
        }
        stage('Plan') {
            steps {
                echo 'Terraform Planning...'
                // Add your test steps here
                dir ("terraform") {
                    sh "terraform plan"
                }
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying...'
                // Add your deploy steps here
                dir ("terraform") { 
                    sh "terraform apply -auto-approve"
                }
            }
        }
        stage('Destroy') {
            when {
                expression { params.operation == 'Destroy' }
            }
            steps {
                echo 'Deploying...'
                // Add your deploy steps here
                dir ("terraform") { 
                    sh "terraform destroy -auto-approve"
                }
            }
        }
    }

    post {
        always {
            echo 'Result.'
        }
        success {
            echo 'This pipeline succeeds.'
        }
        failure {
            echo 'This pipeline fails.'
        }
    }
}