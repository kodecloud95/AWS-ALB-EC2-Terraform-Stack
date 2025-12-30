pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_CREDENTIAL_USR')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_CREDENTIAL_PSW')
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