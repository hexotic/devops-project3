pipeline {
    environment {
        USERNAME = 'projet03ajc'
        IMAGE_NAME = 'projet_django'
        VERSION = 'v1.0.0'
        IMAGE_TAG = "${VERSION}-${env.BUILD_NUMBER}"
    }

    agent none

    stages {

        stage ('Build Application') {
            agent any
            steps {
                script {
                    sh '''
                        docker rm -f $(docker ps -aq) && docker rmi -f $(docker images -aq) || true
                        docker build -t $USERNAME/$IMAGE_NAME:$IMAGE_TAG .
                    '''
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
                       curl http://localhost:80 | head -n 100 | grep -iq "django"
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

                            until scp -i ${keyfile} ${SSH_OPT} docker-compose.yml env_file ${NUSER}@${EC2_IP}:. ; do sleep 1 ; done
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
                        cd $WORKSPACE/terraform/preprod

                        cat ec2-info.txt
                        read EC2_IP IP_PRIV < ec2-info.txt || true

                        # Provisioning with Ansible

                        cd $WORKSPACE/ansible
                        rm -fr roles || true
                        mkdir roles && cd roles
                        git clone https://github.com/hexotic/dockercompose_role.git
                        git clone https://github.com/hexotic/docker_role.git
                        cd ..

                        ansible -i hosts.yml preprod -m ping -e preprod_ip=${IP_PRIV}

                        ansible-playbook -i hosts.yml preprod.yml -e preprod_ip=${IP_PRIV}
                    '''
                }
            }
        }

        stage ('Test pre prod deployment') {
            agent any
            environment {
                AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
                AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
            }

            steps {
                script {
                    sh '''
                       cd $WORKSPACE/terraform/preprod

                       read EC2_IP IP_PRIV < ec2-info.txt || true
                       CURL_OPTS="-v -4 --connect-timeout 10 --retry 10 --retry-connrefused --retry-max-time 40 --retry-delay 10"
                       curl ${CURL_OPTS} -o index.html http://${EC2_IP}:80
                       cat index.html | grep -iq "django"

                       # Attempt to destroy infrastructure but don't fail if a problem occurs.
                       terraform destroy -auto-approve -no-color || true
                   '''
                }
            }
        }

        stage ('Deploy prod infra') {
            agent any
            environment {
                AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
                AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
            }

            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2_prod_private_key', keyFileVariable: 'keyfile', usernameVariable: 'NUSER')]) {
                    catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                        script {
                            timeout(time: 15, unit: 'MINUTES') {
                                input message: 'Do you want to approve deployment in production?', ok: 'Yes'
                            }

                            sh '''
                            pwd
                            echo $WORKSPACE
                            echo $JENKINS_HOME

                            cd terraform/prod
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

                            until scp -i ${keyfile} ${SSH_OPT} docker-compose.yml env_file ${NUSER}@${EC2_IP}:. ; do sleep 1 ; done
                            sleep 10
                        '''
                        }
                    }
                }
            }
        }

        stage('Deploy prod app') {
            agent any
            steps {
                script {
                    sh '''
                        cd $WORKSPACE/terraform/prod
                        cat ec2-info.txt
                        read EC2_IP IP_PRIV < ec2-info.txt || true
                        cd ../../

                        # Provisioning with Ansible

                        cd $WORKSPACE/ansible
                        rm -fr roles || true
                        mkdir roles && cd roles
                        git clone https://github.com/hexotic/dockercompose_role.git
                        git clone https://github.com/hexotic/docker_role.git
                        cd ..

                        ansible -i hosts.yml prod -m ping -e prod_ip=${IP_PRIV}
                        ansible-playbook -i hosts.yml prod.yml -e prod_ip=${IP_PRIV}
                    '''
                }
            }
        }

        stage ('Test prod deployment') {
            agent any

            steps {
                script {
                    sh '''
                       cd $WORKSPACE/terraform/prod

                       read EC2_IP IP_PRIV < ec2-info.txt || true
                       CURL_OPTS="-v -4 --connect-timeout 10 --retry 10 --retry-connrefused --retry-max-time 40 --retry-delay 10"
                       curl ${CURL_OPTS} -o index.html http://${EC2_IP}:80
                       cat index.html | grep -iq "django"
                   '''
                }
            }
        }

    }

    post {
        success{
            slackSend (color: '#00FF00', message: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
        }
        failure {
            slackSend (color: '#FF0000', message: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
        }
    }
}
