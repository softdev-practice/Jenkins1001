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
                sh 'docker stop $(docker ps -a -q)'
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

        stage("installing robot") {
            steps {
                sh 'curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py'
                sh 'python3 get-pip.py'
                sh 'python3 -m pip install --upgrade pip setuptools wheel'
                sh 'python3 -m pip install robotframework'
                sh 'python3 -m pip install robotframework-requests'
            }
        }

        stage("docker compose dev up"){
            steps {
                echo 'Compose Dev up'
                sh 'pwd && ls -al'
                sh 'docker compose -f ./compose.dev.yaml up -d --build'
                sh 'docker compose ps'
                sh 'docker ps'
            }
        }

        stage("robot") {
            steps {
                // echo 'Cloning Robot'
                // dir('./robot/') {
                //     git branch: 'main', url: 'https://github.com/Rosemarries/Jenkins1001.git'
                // }
                echo 'Run Robot'
                sh 'python3 -m robot --outputdir robot_result ./test-plus.robot'
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