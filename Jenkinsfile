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
    if("${label}".equals('Win10_MSI')){
        bat returnStatus: true, script: 'Robocopy . D:\\system\\applications\\cmder\\config\\PowerShell_Modules /E /XF \'.gitignore\' /XD \'ZeroSpace\''
    }

    if("${label}".equals('Win10-VB')){
        
    }
}

pipeline{
    agent none
    
    parameters {
        choice choices: ['Win10_MSI', 'Win10-VB'], description: 'Choose an agent for deployment', name: 'AGENT'
        credentials credentialType: 'com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey', 
                    defaultValue: '', 
                    name: 'GIT_REPO_CRED', 
                    required: true
    }

    stages {
        stage('Prepare for building') {
            agent {
                label 'master'
            }

            stages{
                stage('Check status agent/git cred'){
                    steps{
                        CheckAgent("${params.AGENT}")
                        CheckGitCred("$params.GIT_REPO_CRED")
                    }
                }

                stage('Git checkout'){
                    steps {
                        git branch: 'main', 
                        credentialsId: "${params.GIT_REPO_CRED}", 
                        poll: false, 
                        url: 'git@github.com:Serhii5465/powershell_cmder_cfg.git'

                        stash excludes: 'README.md', name: 'src'
                    }
                }
            }
        }

        stage('Deploy'){
            agent {
                label "${params.AGENT}"
            }

            steps{
                unstash 'src'
               
                // script{
                //     if("${params.AGENT}".equals('Win10_MSI')){
                //         bat returnStatus: true, script: 'Robocopy . D:\\system\\applications\\cmder\\config\\PowerShell_Modules /E /XF ".gitignore" /XD "ZeroSpace"'
                //     }
                // }
            }
        }
    }
}