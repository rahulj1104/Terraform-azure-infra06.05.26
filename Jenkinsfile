pipeline {
    agent any

    environment {
        TF = "C:\\Program Files\\TERRAFORM\\terraform.exe"
    }

    stages {

        stage('Terraform Version') {
            steps {
                bat "${env.TF} version"
            }
        }

        stage('Init') {
            steps {
                bat "${env.TF} init"
            }
        }

        stage('Validate') {
            steps {
                bat "${env.TF} validate"
            }
        }

        stage('Plan') {
            steps {
                bat "${env.TF} plan"
            }
        }
    }
}