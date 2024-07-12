pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/adhie16/sample-node-app.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    def app = docker.build("sample-node-app:${env.BUILD_ID}")
                }
            }
        }
        stage('Run Tests') {
            steps {
                script {
                    docker.image("sample-node-app:${env.BUILD_ID}").inside {
                        sh 'npm test'
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    def container = docker.image("sample-node-app:${env.BUILD_ID}").run("-d -p 3000:3000")
                    // Save container ID to a file for later use
                    writeFile file: 'containerId.txt', text: container.id
                }
            }
        }
        stage('Check Deployment') {
            steps {
                script {
                    // Read container ID from file
                    def containerId = readFile('containerId.txt').trim()
                    // Check if container is running
                    def isRunning = sh(script: "docker ps -q -f id=${containerId}", returnStdout: true).trim()
                    if (isRunning == "") {
                        error "Container ${containerId} is not running!"
                    } else {
                        echo "Container ${containerId} is running successfully."
                    }
                }
            }
        }
    }
}
