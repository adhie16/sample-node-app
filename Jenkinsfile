pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                checkout([$class: 'GitSCM',
                          branches: [[name: '*/main']],
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
        stage('Deploy') {
            steps {
                script {
                    def app = docker.image("sample-node-app:${env.BUILD_ID}")
                    def container = app.run("-p 3000:3000 -d")
                    // Optionally, save container ID to file
                    writeFile file: 'containerId.txt', text: container.id
                }
            }
        }
    }
}
