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
                sh 'npm i'
                sh 'docker build -t gitlab-registry-demo .'
            }
        }

        stage("test") {
            steps {
                echo 'testing the application...'
                sh 'npm test'
            }
        }

        stage("deploy") {
            steps {
                echo 'deploying the application...'
                sh 'npm start'
            }
        }

        stage("push to registry") {
            steps {
                withCredentials([
                    usernamePassword(credentials: 'gitlab-profile', usernameVariable: GITLAB_USER, passwordVariable: GITLAB_ACCESS_TOKEN)
                ]) {
                    sh "docker login registry.gitlab.com -u ${GITLAB_USER} -p ${GITLAB_ACCESS_PASSWD}"
                }
                echo 'Login Success!'
            }
        }
    }
}