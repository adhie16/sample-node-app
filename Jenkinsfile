pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                checkout([$class: 'GitSCM',
                          branches: [[name: 'main']],
                          userRemoteConfigs: [[url: 'https://github.com/adhie16/sample-node-app.git']]
                ])
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    def app = docker.build("sample-node-app:${env.BUILD_ID}")
                    app.inside {
                        sh 'npm install'
                        sh 'npm start'
                    }
                }
            }
        }
        stage('Run Tests') {
            steps {
                script {
                    def app = docker.image("sample-node-app:${env.BUILD_ID}")
                    app.inside {
                        sh 'npm test'
                    }
                }
            }
        }
        stage('Deploy to Server') {
            steps {
                script {
                    // Build and push Docker image to a registry (if needed)
                    docker.withRegistry('https://your-docker-registry/', 'docker-credentials-id') {
                        def app = docker.image("sample-node-app:${env.BUILD_ID}")
                        app.push()
                    }

                    // SSH ke server dan deploy aplikasi
                    sshagent(credentials: ['bf91efde-9f23-4abf-af9d-720fd184a424']) {
                        sh 'ssh cws@192.168.5.7 "docker pull sample-node-app:${env.BUILD_ID}"'
                        sh 'ssh cws@192.168.5.7 "docker stop sample-node-app || true"'
                        sh 'ssh cws@192.168.5.7 "docker rm sample-node-app || true"'
                        sh 'ssh cws@192.168.5.7 "docker run -d -p 3000:3000 --name sample-node-app sample-node-app:${env.BUILD_ID}"'
                    }
                }
            }
        }
    }
}
