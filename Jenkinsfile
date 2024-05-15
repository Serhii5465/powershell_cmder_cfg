def CheckAgent(String label){
    online_nodes = nodesByLabel label: "${label}", offline: false
    if (online_nodes) {
        echo "${label} online"
    } else {
       currentBuild.result = 'ABORTED'
       error("${label} offline. Aborting building")
    }
}

def CheckGitCred(String data){
    if ("${data}".isEmpty()) {
        currentBuild.result = 'ABORTED'
        error("Enter GitHub credentials...")
    }
}


def DeployArtifacts(String label){
    def path_ps_user_prof = "D:\\system\\applications\\cmder\\config"
    def path_ps_modules = "${path_ps_user_prof}\\PowerShell_Modules"

    def file_prof = "user_profile.ps1"

    def zero_space_module = "ZeroSpace"
    def comp_vdi_module = "CompressVDI"
    def rest_cyg_module = "RestoreCygwin"

    bat returnStatus: true, script: """robocopy . ${path_ps_user_prof} ${file_prof}"""

    if ("${label}" == "Win10_MSI"){
        bat returnStatus: true, script: """robocopy /E . ${path_ps_modules} /XF ${file_prof} /XD ${zero_space_module}"""
    }

    if("${label}" == "Win10-VB"){
        bat returnStatus: true, script: """robocopy /E . ${path_ps_modules} /XF ${file_prof} /XD ${comp_vdi_module} ${rest_cyg_module}"""
    }
}

pipeline{
    agent {
        label 'master'
    }
    
     options { 
        skipDefaultCheckout() 
    }

    parameters {
        choice choices: ['Win10_MSI', 'Win10-VB'], description: 'Choose an agent for deployment', name: 'AGENT'
        credentials credentialType: 'com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey', 
                    defaultValue: '', 
                    name: 'GIT_REPO_CRED', 
                    required: true
    }

    stages {
        stage('Check status agent/git cred') {
            steps {
                CheckAgent("${params.AGENT}")
                CheckGitCred("${params.GIT_REPO_CRED}")
            }
        }

        stage('Git checkout') {
            steps {
                git branch: 'main', 
                credentialsId: "${params.GIT_REPO_CRED}", 
                poll: false, 
                url: 'git@github.com:Serhii5465/powershell_cmder_cfg.git'

                stash excludes: 'README.md, Jenkinsfile', name: 'src'
            }
        }
    
        stage('Deploy'){
            agent {
                label "${params.AGENT}"
            }

            steps{
                unstash 'src'
                
                script {
                    DeployArtifacts("${params.AGENT}")
                }
            }
        }
    }
}