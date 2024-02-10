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
            }
        }

        stage("test") {
            steps {
                echo 'testing the application...'
            }
        }

        stage("deploy") {
            steps {
                echo 'deploying the application...'
            }
        }

        stage("push to registry") {
            withCredentials([
                usernamePassword(credentials: 'gitlab-profile', usernameVariable: GITLAB_USER, passwordVariable: GITLAB_ACCESS_TOKEN)
            ]) {
                sh "docker login registry.gitlab.com -u ${GITLAB_USER} -p ${GITLAB_ACCESS_PASSWD}"
            }
        }
    }
}