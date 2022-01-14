pipeline {
    environment {
        USERNAME = 'projet03ajc'
        IMAGE_NAME = 'projet_django'
        VERSION = 'v1.0.0'
        IMAGE_TAG = "${VERSION}-${env.BUILD_NUMBER}"
        STAGING = 'projetajc-group1-preprod'
        PRODUCTION = 'projetajc-group1-prod'
        CONTAINER_NAME = 'web'
        EC2_PRODUCTION_HOST = '54.160.242.209'
    }

    agent none

    stages {

        stage ('Build Application') {
            agent any
            steps {
                script {
                    sh 'docker rm -f $(docker ps -aq) && docker rmi -f $(docker images -aq) || true'
                    sh 'docker build -t $USERNAME/$IMAGE_NAME:$IMAGE_TAG .'
                }
            }
        }

        stage('Security scan') {
            agent any
            environment {
                SNYK_TOKEN = credentials('SNYK_SECRET')
            }
            steps {
                sh """
                    snyk auth ${SNYK_TOKEN}
                    snyk container test --file=$WORKSPACE/Dockerfile $USERNAME/$IMAGE_NAME:$IMAGE_TAG || true
                """
            }
        }

        stage ('Run test containers') {
            agent any
            steps {
                script {
                    sh '''
                       docker-compose up -d
                       sleep 5
                   '''
                }
            }
        }


        stage ('Test application') {
            agent any
            steps {
                script {
                    sh '''
                       curl http://localhost:8000 | head -n 100 | grep -iq "django"
                   '''
                }
            }
        }

        stage ('Save artifact') {
            agent any
            environment {
                PASSWORD = credentials('dockerhub_password')
            }
            steps {
                script {
                    sh '''
                       docker login -u $USERNAME -p $PASSWORD
                       docker push $USERNAME/$IMAGE_NAME:$IMAGE_TAG
                       docker-compose down -v --rmi all || true
                   '''
                }
            }
        }

        stage ('Deploy pre prod infra') {
            agent any
            environment {
                AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
                AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
            }

            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2_prod_private_key', keyFileVariable: 'keyfile', usernameVariable: 'NUSER')]) {
                    catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                        script {
                            sh '''
                            pwd
                            echo $WORKSPACE
                            echo $JENKINS_HOME

                            cd terraform/preprod
                            terraform init -no-color
                            terraform destroy -auto-approve -no-color
                            terraform plan -no-color
                            terraform apply -auto-approve -no-color
                            sleep 10

                            cat ec2-info.txt
                            read EC2_IP IP_PRIV < ec2-info.txt || true
                            cd ../../

                            echo "USERNAME=${USERNAME}" > env_file
                            echo "IMAGE_NAME=${IMAGE_NAME}" >> env_file
                            echo "IMAGE_TAG=${IMAGE_TAG}" >> env_file

                            SSH_OPT="-o StrictHostKeyChecking=no -o ConnectTimeout=30 -o ConnectionAttempts=10"

                            scp -i ${keyfile} ${SSH_OPT} docker-compose.yml env_file ${NUSER}@${EC2_IP}:.
                            sleep 10
                        '''
                        }
                    }
                }
            }
        }

        stage ('Deploy pre prod app') {
            agent any

            steps {
                    script {
                            sh '''
                            cd terraform/preprod
                            cat ec2-info.txt
                            read EC2_IP IP_PRIV < ec2-info.txt || true
                            cd ../../

                            # Provisioning with Ansible

                            cd ansible
                            rm -fr roles || true
                            mkdir roles && cd roles
                            git clone https://github.com/hexotic/dockercompose_role.git
                            git clone https://github.com/hexotic/docker_role.git
                            cd ..

                            ansible -i hosts.yml preprod -m ping -e preprod_ip=${IP_PRIV}

                            ansible-playbook -i hosts.yml main.yml -e preprod_ip=${IP_PRIV}
                        '''
                    }
            }
        }

        stage ('Test pre prod deployment') {
            agent any

            steps {
                script {
                    sh '''
                       cd $WORKSPACE/terraform/preprod

                       read EC2_IP IP_PRIV < ec2-info.txt || true
                       curl --retry 10 http://${EC2_IP}:8000 > index.html
                       cat index.html | grep -iq "django"

                       terraform destroy -auto-approve -no-color
                   '''
                }
            }
        }

        stage('Deploy app on EC2-cloud Production') {
            agent any
            when {
                expression { GIT_BRANCH == 'origin/master' }
            }
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2_prod_private_key', keyFileVariable: 'keyfile', usernameVariable: 'NUSER')]) {
                    catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                        script {
                            timeout(time: 15, unit: 'MINUTES') {
                                input message: 'Do you want to approve the deploy in production?', ok: 'Yes'
                            }

                            sh'''
                                ssh -o StrictHostKeyChecking=no -i ${keyfile} ${NUSER}@${EC2_PRODUCTION_HOST} docker build -t $USERNAME/$IMAGE_NAME:$IMAGE_TAG .
                                ssh -o StrictHostKeyChecking=no -i ${keyfile} ${NUSER}@${EC2_PRODUCTION_HOST} docker-compose up -d
                            '''
                        }
                    }
                }
            }
        }

    // stage('Deploy app on EC2-cloud Production test') {
    //     agent {
    //         docker {
    //             image('alpine')
    //             args ' -u root'
    //         }
    //     }
    //     when{
    //         expression{ GIT_BRANCH == 'origin/master'}
    //     }
    //     steps{
    //         withCredentials([sshUserPrivateKey(credentialsId: "ec2_prod_private_key", keyFileVariable: 'keyfile', usernameVariable: 'NUSER')]) {
    //             catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
    //                 script{
    //                     timeout(time: 15, unit: "MINUTES") {
    //                         input message: 'Do you want to approve the deploy in production?', ok: 'Yes'
    //                     }
    //                     sh'''
    //                         apk update
    //                         which ssh-agent || ( apk add openssh-client )
    //                         eval $(ssh-agent -s)
    //                         ssh -o StrictHostKeyChecking=no -i ${keyfile} ${NUSER}@${EC2_PRODUCTION_HOST} docker stop $CONTAINER_NAME || true
    //                         ssh -o StrictHostKeyChecking=no -i ${keyfile} ${NUSER}@${EC2_PRODUCTION_HOST} docker rm $CONTAINER_NAME || true
    //                         ssh -o StrictHostKeyChecking=no -i ${keyfile} ${NUSER}@${EC2_PRODUCTION_HOST} docker rmi $USERNAME/$IMAGE_NAME:$IMAGE_TAG || true
    //                         ssh -o StrictHostKeyChecking=no -i ${keyfile} ${NUSER}@${EC2_PRODUCTION_HOST} docker run --name $CONTAINER_NAME -d -e PORT=5000 -p 5000:5000 $USERNAME/$IMAGE_NAME:$IMAGE_TAG
    //                     '''
    //                 }
    //             }
    //         }
    //     }
    // }
    }

// post {
//     success{
//         slackSend (color: '#00FF00', message: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
//     }
//     failure {
//         slackSend (color: '#FF0000', message: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
//     }
// }
}
