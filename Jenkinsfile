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
        withCredentials([
            string(credentialsId: 'Subscription id', variable: 'TF_VAR_subscription_id'),
            string(credentialsId: 'Client id', variable: 'TF_VAR_client_id'),
            string(credentialsId: 'Client secret', variable: 'TF_VAR_client_secret'),
            string(credentialsId: 'Tenant id', variable: 'TF_VAR_tenant_id')
        ]) {

           

            bat '"C:\\Program Files\\TERRAFORM\\terraform.exe" plan -var-file=nonsecretterraform.tfvars'
            
        }
                }
            }
        }

        stage('Apply') {
            steps {

                withCredentials([
                    string(credentialsId: 'Subscription id', variable: 'TF_VAR_subscription_id'),
                    string(credentialsId: 'Client id', variable: 'TF_VAR_client_id'),
                    string(credentialsId: 'Client secret', variable: 'TF_VAR_client_secret'),
                    string(credentialsId: 'Tenant id', variable: 'TF_VAR_tenant_id')
                ]) {

                    bat '"C:\\Program Files\\TERRAFORM\\terraform.exe" apply -auto-approve -var-file=nonsecretterraform.tfvars'

                }
            }
        }
    }
}
