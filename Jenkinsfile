pipeline {
    agent any

    stages {

        stage('Terraform Version') {
            steps {
                bat '"C:\\Program Files\\TERRAFORM\\terraform.exe" version'
            }
        }

        stage('Init') {
            steps {
                bat '"C:\\Program Files\\TERRAFORM\\terraform.exe" init'
            }
        }

        stage('Validate') {
            steps {
                bat '"C:\\Program Files\\TERRAFORM\\terraform.exe" validate'
            }
        }

        stage('Plan') {
            steps {
                 bat '"C:\\Program Files\\TERRAFORM\\terraform.exe" plan -var-file=nonsecretterraform.tfvars'
            }
        }
        stage('Apply') {
    steps {
        bat '"C:\\Program Files\\TERRAFORM\\terraform.exe" apply -auto-approve -var-file=nonsecretterraform.tfvars"'
    }
}
    }
}