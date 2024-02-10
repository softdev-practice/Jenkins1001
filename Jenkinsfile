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
                withCredentials([
                    usernamePassword(credentials: 'dockerhub', usernameVariable: DOCKERHUB_USER, passwordVariable: DOCKERHUB_PASSWD)
                ]) {
                    sh "some script ${USER} ${PASSWD}"
                }
            }
        }
    }
}