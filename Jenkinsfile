// CODE_CHANGES = getGitChanges()

pipeline {
    agent none

    tools {
        nodejs "NodeJS"
    }

    stages {
        stage("clear containers and images if exist") {
            agent any
            when {
                expression {
                    BRANCH_NAME == 'main'
                }
            }
            steps {
                script {
                    def runningContainers = sh(script: 'docker ps -q | wc -l', returnStdout: true).trim().toInteger()
                    
                    if (runningContainers > 0) {
                        sh 'docker stop $(docker ps -a -q)'
                    } else {
                        echo "No action required. Running container count: $runningContainers"
                    }
                }
            }
        }

        stage("build") {
            agent { label 'test' }
            when {
                expression {
                    BRANCH_NAME == 'main'
                }
            }
            steps {
                echo 'building the application...'
                sh 'npm install --global yarn'
                sh 'yarn install'
            }
        }

        stage("test") {
            agent { label 'test' }
            steps {
                echo 'testing the application...'
                sh 'yarn test'
            }
        }

        stage("docker compose dev up"){
            agent { label 'test' }
            steps {
                echo 'Compose Dev up'
                sh 'pwd && ls -al'
                sh 'docker compose -f ./compose.dev.yaml up -d --build'
                sh 'docker compose ps'
                sh 'docker ps'
            }
        }

        stage("robot") {
            agent { label 'test' }
            steps {
                echo 'Check for ./robot/'
                sh 'mkdir -p robot'
                echo 'Cloning Robot'
                dir('./robot/') {
                    git branch: 'main', url: 'https://github.com/Rosemarries/robot.git'
                }
                echo 'Run Robot'
                sh 'cd robot && python3 -m robot --outputdir robot_result ./test-plus.robot'
            }
        }

        stage("push to registry") {
            agent { label 'test' }
            steps {
                echo 'Logining in...'
                withCredentials([
                    usernamePassword(credentialsId: 'jenkins_test', usernameVariable: 'DEPLOY_USER', passwordVariable: 'DEPLOY_TOKEN')
                ]) {
                    sh "docker login registry.gitlab.com -u ${DEPLOY_USER} -p ${DEPLOY_TOKEN}"
                }
                sh "docker build -t registry.gitlab.com/softdev-practice/jenkins1001 ."
                sh "docker push registry.gitlab.com/softdev-practice/jenkins1001"
                echo 'Push Success!'
            }
        }

        stage("compose down and prune") {
            agent { label 'test' }
            steps {
                echo 'Cleaning'
                sh 'docker compose -f ./compose.dev.yaml down'
                sh 'docker system prune -a -f'
            }
        }

        stage("pull image from registry") {
            agent { label 'pre-prod' }
            steps {
                echo 'Logining in...'
                withCredentials([
                    usernamePassword(credentialsId: 'jenkins_test', usernameVariable: 'DEPLOY_USER', passwordVariable: 'DEPLOY_TOKEN')
                ]) {
                    sh "docker login registry.gitlab.com -u ${DEPLOY_USER} -p ${DEPLOY_TOKEN}"
                }
                sh "docker pull registry.gitlab.com/softdev-practice/jenkins1001"
                sh "docker run -d -p 5000:5000 registry.gitlab.com/softdev-practice/jenkins1001"
                echo 'Create Container Success!'
            }
        }
    }
}