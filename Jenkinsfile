/* groovylint-disable CompileStatic, DuplicateStringLiteral, GStringExpressionWithinString, LineLength, NestedBlockDepth */
pipeline {
    agent any

    parameters {
        string(name: 'ENVIRONMENT', defaultValue: 'dev', description: 'The environment to deploy (dev, staging, prod)')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')      // AWS credentials stored in Jenkins
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')  // AWS credentials stored in Jenkins
        EMAIL_RECIPIENTS      = 'pdasari17@gmail.com'                 // Recipient for email notifications
        TF_VAR_FILE           = "${params.ENVIRONMENT}.tfvars"        // Set the Terraform variable file based on environment
        HELM_RELEASE_NAME     = "webapp-${params.ENVIRONMENT}"         // Helm release name based on environment
        HELM_CHART_PATH       = './app-helmcharts'                  // Path to the Helm chart
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the source code (Terraform scripts and Helm chart) from the repository
                git url: 'https://github.com/pkdasari/coding-assignment-1.git', branch: 'main'
            }
        }

        stage('Select Terraform Workspace') {
            steps {
                script {
                    // Select the workspace based on the environment parameter
                    sh """
                        terraform workspace select ${params.ENVIRONMENT} || terraform workspace new ${params.ENVIRONMENT}
                    """
                }
            }
        }

        stage('Terraform Init') {
            steps {
                // Initialize Terraform
                script {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                // Run Terraform Plan for the selected environment
                script {
                    sh 'terraform plan -var-file=${TF_VAR_FILE} -out=tfplan-${params.ENVIRONMENT}'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                // Apply the infrastructure changes for the selected environment
                script {
                    sh 'terraform apply -auto-approve tfplan-${params.ENVIRONMENT}'
                }
            }
        }
        stage('Helm Deploy') {
            steps {
                script {
                    // Fetch the KUBECONFIG from Jenkins secret based on the environment
                    withCredentials([file(credentialsId: "kubeconfig-${params.ENVIRONMENT}", variable: 'KUBECONFIG')]) {
                        sh """
                            helm upgrade --install ${HELM_RELEASE_NAME} ${HELM_CHART_PATH} \\
                            --kubeconfig $KUBECONFIG \\
                            --set environment=${params.ENVIRONMENT} \\
                            --namespace ${params.ENVIRONMENT}
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            // Email notification on success
            emailext(
                to: "$EMAIL_RECIPIENTS",
                subject: "Terraform & Helm Deployment - ${params.ENVIRONMENT} - SUCCESS",
                body: """
                    <p>Hello,</p>
                    <p>Your Terraform infrastructure provisioning and Helm deployment for <b>${params.ENVIRONMENT}</b> has completed successfully.</p>
                    <p>Details:</p>
                    <ul>
                        <li>Environment: ${params.ENVIRONMENT}</li>
                        <li>Branch: ${env.BRANCH_NAME}</li>
                        <li>Build URL: ${env.BUILD_URL}</li>
                        <li>Job Name: ${env.JOB_NAME}</li>
                    </ul>
                    <p>Regards,<br>Jenkins</p>
                """,
                mimeType: 'text/html'
            )
        }

        failure {
            // Email notification on failure
            emailext(
                to: "$EMAIL_RECIPIENTS",
                subject: "Terraform & Helm Deployment - ${params.ENVIRONMENT} - FAILURE",
                body: """
                    <p>Hello,</p>
                    <p>Your Terraform infrastructure provisioning and Helm deployment for <b>${params.ENVIRONMENT}</b> has failed.</p>
                    <p>Details:</p>
                    <ul>
                        <li>Environment: ${params.ENVIRONMENT}</li>
                        <li>Branch: ${env.BRANCH_NAME}</li>
                        <li>Build URL: ${env.BUILD_URL}</li>
                        <li>Job Name: ${env.JOB_NAME}</li>
                    </ul>
                    <p>Check the Jenkins logs for more information.</p>
                    <p>Regards,<br>Jenkins</p>
                """,
                mimeType: 'text/html'
            )
        }
    }
}
