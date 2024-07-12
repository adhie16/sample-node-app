pipeline {
    agent any

    environment {
        imageName = "sample-node-app"
        remoteServer = "cws@192.168.5.7"
        sshCredentials = 'bf91efde-9f23-4abf-af9d-720fd184a424'  // Ganti dengan ID kredensial SSH yang ditambahkan ke Jenkins
    }

    stages {
        stage('Clone Repository') {
            steps {
                checkout([$class: 'GitSCM',
                          branches: [[name: 'main']],
                          userRemoteConfigs: [[url: 'https://github.com/username/sample-node-app.git']]
                ])
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    def dockerImage = docker.build(imageName)
                    dockerImage.push()
                }
            }
        }

        stage('Save and Load Docker Image Locally') {
            steps {
                script {
                    docker.image(imageName).save("${imageName}_${env.BUILD_ID}.tar")
                    sshagent(credentials: [sshCredentials]) {
                        sh "scp ${imageName}_${env.BUILD_ID}.tar ${remoteServer}:~/"
                    }
                    sh "rm ${imageName}_${env.BUILD_ID}.tar"
                }
            }
        }

        stage('Deploy to Server') {
            steps {
                script {
                    sshagent(credentials: [sshCredentials]) {
                        sh "ssh ${remoteServer} 'docker load -i ~/${imageName}_${env.BUILD_ID}.tar'"
                        sh "ssh ${remoteServer} 'docker stop ${imageName} || true'"
                        sh "ssh ${remoteServer} 'docker rm ${imageName} || true'"
                        sh "ssh ${remoteServer} 'docker run -d -p 3000:3000 --name ${imageName} ${imageName}:${env.BUILD_ID}'"
                    }
                }
            }
        }
    }
}
