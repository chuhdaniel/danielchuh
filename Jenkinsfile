pipeline {
    agent any

    // environment {
    //     KUBE_CONFIG = credentials('your-kube-config-credential-id')
    //     HELM_CHART_PATH = '.helm/'
    //     PYTHON_VERSION = '3.11'
    //     ECR_REGISTRY_URL = '0123456789.dkr.ecr.us-east-1.amazonaws.com'
    //     ECR_REPOSITORY = 'engineering'
    //     AWS_DEFAULT_REGION = 'us-east-1'
    //     DOCKER_IMAGE_NAME = 'oimis-fe'
    //     DOCKERFILE_PATH = './Dockerfile'
    //     APP_NAME = 'oimis-fe'
    // }

    stages {
        stage('Checkout') {
            steps {
                script {
                    checkout scm
                }
            }
        }

        // stage('Build') {
        //     steps {
        //         sh 'mvn clean package' 
        //     }
        // }

        stage('install dependencies') {
        steps {
            // there a few default environment variables on Jenkins
            // on local Jenkins machine (assuming port 8080) see
            // http://localhost:8080/pipeline-syntax/globals#env
            // echo "Running build ${env.BUILD_ID} on ${env.JENKINS_URL}"
            sh 'npm install'
            sh 'npm audit fix --force'
        }
        }

        stage('build') {
        steps {
            // there a few default environment variables on Jenkins
            // on local Jenkins machine (assuming port 8080) see
            // http://localhost:8080/pipeline-syntax/globals#env
            echo "Running build ${env.BUILD_ID} on ${env.JENKINS_URL}"
            sh 'npm ci'
            sh 'npm run cy:verify'
        }
        }

        stage('start local server') {
        steps {
            // start local server in the background
            // we will shut it down in "post" command block
            sh 'nohup npm run start &'
        }
        }

        stage('cypress parallel tests') {
            environment {
                // we will be recording test results on Cypress Cloud
                // to record we need to set an environment variable
                // we can load the record key variable from credentials store
                // see https://jenkins.io/doc/book/using/using-credentials/
                CYPRESS_RECORD_KEY = credentials('cypress-example-kitchensink-record-key')
                // because parallel steps share the workspace they might race to delete
                // screenshots folders. Tell Cypress not to delete these folders
                CYPRESS_trashAssetsBeforeRuns = 'false'
            }

            // https://jenkins.io/doc/book/pipeline/syntax/#parallel
            parallel {
                // start several test jobs in parallel, and they all
                // will use Cypress Cloud to load balance any found spec files
                stage('tester A') {
                steps {
                    echo "Running build ${env.BUILD_ID}"
                    sh "npm run e2e:record:parallel"
                }
                }

                // second tester runs the same command
                stage('tester B') {
                steps {
                    echo "Running build ${env.BUILD_ID}"
                    sh "npm run e2e:record:parallel"
                }
                }
            }

        }

        // stage('SonarQube Analysis') {
        //     steps {
        //         script {
        //             withSonarQubeEnv('SonarQube_Server') {
        //                 sh 'mvn sonar:sonar'
        //             }
        //         }
        //     }            
        // }

        // stage('SonarQube Quality Gate Check') {
        //     steps {
        //         script {
        //             def qualityGate = waitForQualityGate() 
        //             if (qualityGate.status != 'OK') {
        //                 error "Quality Gate check failed: ${qualityGate.status}"
        //             }
        //         }
        //     }
        //     dependencies {
        //         stage ('SonarQube Analysis')
        //     }
        // }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    // Login to ECR
                    // withCredentials([string(credentialsId: 'your-ecr-credentials-id', variable: 'AWS_ECR_CREDENTIALS')]) {
                    //     sh """
                    //         aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY_URL}
                    //     """
                    // }

                    // Build and tag the Docker image
                    sh """
                        docker build -t ${DOCKER_IMAGE_NAME} -f ${DOCKERFILE_PATH} .
                        docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION} ${ECR_REGISTRY_URL}/${ECR_REGISTRY}
                    """

                    // Push the Docker image to ECR
                    // sh "docker push ${ECR_REGISTRY_URL}/${ECR_REGISTRY}"
                }
            }
            // dependencies {
            //     stage ('SonarQube Quality Gate Check')
            // }
        }

        stage('Helm Deploy') {
            steps {
                script {
                    // Install Helm
                    sh """
                        curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
                        chmod +x get_helm.sh
                        ./get_helm.sh
                    """

                    // Deploy Helm chart
                    sh """
                        helm upgrade --install ${env.APP_NAME} ${env.HELM_CHART_PATH} --namespace your-namespace
                    """
                }
            }
        }
    }

    post {
        always {
            // archive test results
            junit 'reports/**/*.xml'
        }
    }
}