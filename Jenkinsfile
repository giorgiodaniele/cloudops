pipeline {
    agent any
    parameters {
        string(
            name:         "group",
            defaultValue: "BigliettoDigitale",
            description:  ""
        )
        string(
            name:         "project",
            defaultValue: "pl-bigliettodigitale",
            description:  ""
        )
        string(
            name:         "branch",
            defaultValue: "master",
            description:  ""
        )
        choice(
            name:        "action",
            choices:     ["up", "down"],
            description: "Azione da eseguire sul deployment"
        )
    }
    environment {
        ARM_CLIENT_ID            = credentials("ARM_CLIENT_ID")
        ARM_SUBSCRIPTION_ID      = credentials("ARM_SUBSCRIPTION_ID")
        ARM_TENANT_ID            = credentials("ARM_TENANT_ID")
        ARM_CLIENT_SECRET        = credentials("ARM_CLIENT_SECRET")
        PULUMI_CONFIG_PASSPHRASE = "SECRET"
    }
    stages {

        stage("CHECKOUT") {
            steps {
                git(
                    url:           "http://gitea:3000/${params.group}/${params.project}.git",
                    branch:        params.branch,
                    credentialsId: "GIT_ADMIN_ACCESS_PASSWORD"
                )
            }
        }

        stage("INIT") {
            steps {
                script {
                    sh """python3 -m venv venv"""
                    sh """. venv/bin/activate && pip install -r requirements.txt"""
                    sh """. venv/bin/activate && pulumi stack select organization/${params.group}_${params.project}/${params.branch} 2>/dev/null || pulumi stack init organization/${params.group}_${params.project}/${params.branch}
                    """
                }
            }
        }

        stage("REMEDIATE") {
            steps {
                script {
                    sh """printf 'from transform import *\\nregister_all()\\n' | cat - __main__.py > tmp && mv tmp __main__.py"""
                    sh """
                    cat __main__.py
                    """
                }
            }
        }

        stage("DEPLOY") {
            steps {
                script {
                    sh ". venv/bin/activate && pulumi ${params.action} --yes --skip-preview"
                }
            }
        }

        stage("DELETE") {
            steps {
                script {
                    sh "rm -rf *"
                }
            }
        }
    }
}