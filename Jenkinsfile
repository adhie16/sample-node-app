pipeline {
    agent any

    environment {
        // Sesuaikan dengan nama credentials SSH yang sudah ditambahkan di Jenkins
        SSH_CREDENTIALS = 'bf91efde-9f23-4abf-af9d-720fd184a424'
        // Sesuaikan dengan nama registry Docker Anda jika digunakan
        DOCKER_REGISTRY = ''
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Checkout repositori dari GitHub
                checkout([$class: 'GitSCM',
                          branches: [[name: '*/main']],
                          userRemoteConfigs: [[url: 'https://github.com/adhie16/sample-node-app.git']]
                ])
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build image Docker
                    def dockerImage = docker.build("nginx-app:${env.BUILD_ID}")
                    // Push image ke registry Docker jika diperlukan
                    docker.withRegistry('', 'docker-credentials') {
                        dockerImage.push()
                    }
                }
            }
        }

        stage('Deploy to Server') {
            steps {
                script {
                    // Deploy image Docker ke server dengan SSH
                    sshagent(credentials: ['${SSH_CREDENTIALS}']) {
                        sh "ssh cws@192.168.5.7 'docker pull nginx-app:${env.BUILD_ID}'"
                        sh "ssh cws@192.168.5.7 'docker stop nginx-container || true'"
                        sh "ssh cws@192.168.5.7 'docker rm nginx-container || true'"
                        sh "ssh cws@192.168.5.7 'docker run -d -p 80:80 --name nginx-container nginx-app:${env.BUILD_ID}'"
                    }
                }
            }
        }
    }
}
