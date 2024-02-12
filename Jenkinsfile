// CODE_CHANGES = getGitChanges()

pipeline {
    agent any

    tools {
        nodejs "NodeJS"
    }

    stages {
        stage("build") {
            when {
                expression {
                    // (BRANCH_NAME == 'dev' || BRANCH_NAME == 'main') && CODE_CHANGES
                    BRANCH_NAME == 'dev' || BRANCH_NAME == 'main'
                }
            }
            steps {
                echo 'building the application...'
                sh 'npm install --global yarn'
                sh 'yarn install'
            }
        }

        stage("test") {
            steps {
                echo 'testing the application...'
                sh 'yarn test'
            }
        }

        stage("robot") {
            steps {
                echo 'Compose Dev up'
                sh 'pwd && ls -al'
                sh 'docker compose -f ./compose.dev.yaml up -d --build'
                echo 'Cloning Robot'
                dir('./robot/') {
                    git branch: 'main', url: 'https://github.com/Rosemarries/Jenkins1001.git'
                }
                echo 'Run Robot'
                sh 'cd ./robot && robot --outputdir robot_result ./test-plus.robot'
            }
        }

        stage("push to registry") {
            steps {
                // withCredentials([
                //     usernamePassword(credentialsId: 'gitlab-profile', usernameVariable: GITLAB_USER, passwordVariable: GITLAB_ACCESS_TOKEN)
                // ]) {
                //     sh "docker login registry.gitlab.com -u ${GITLAB_USER} -p ${GITLAB_ACCESS_PASSWD}"
                    sh "docker build -t registry.gitlab.com/softdev-practice/jenkins1001 ./app"
                    sh "docker push registry.gitlab.com/softdev-practice/jenkins1001"
                // }
                echo 'Push Success!'
            }
        }

        stage("compose down and prune") {
            steps {
                echo 'Cleaning'
                sh 'docker compose -f ./compose.dev.yaml down'
                sh 'docker system prune -a -f'
            }
        }

        stage("deploy") {
            steps {
                echo 'deploying the application...'
                sh 'docker compose up -d --build'
            }
        }
    }
}