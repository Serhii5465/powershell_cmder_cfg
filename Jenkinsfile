@Library(['PrepEnvForBuild', 'DeployWinAgents']) _

def DeployModules = { String label ->
    def path_user_prof = "D:\\system\\applications\\cmder\\config"
    def path_modules = "${path_user_prof}\\PowerShell_Modules"

    def file_prof = "user_profile.ps1"
    def zero_space_module = "ZeroSpace"
    def comp_vdi_module = "CompressVDI"

    bat returnStatus: true, script: """robocopy . ${path_user_prof} ${file_prof}"""

    if (label.contains('Dell') || label.contains('MSI')){
        bat returnStatus: true, script: """robocopy /E . ${path_modules} /XF ${file_prof} /XD ${zero_space_module}"""
    }

    if (label.contains('VBox_VM')) {
        bat returnStatus: true, script: """robocopy /E . ${path_modules} /XF ${file_prof} /XD ${comp_vdi_module}"""
    }
}

node('master') {
    def config = [
        git_repo_url : "powershell_cmder_cfg_repo:Serhii5465/powershell_cmder_cfg.git",
        git_branch : "main",
        stash_includes : "",
        stash_excludes : "README.md, Jenkinsfile",
        command_deploy : "robocopy /E . D:\\system\\scripts\\sync_data",
        func_deploy : DeployModules
    ]

    DeployArtifactsPipelineWinAgents(config)
}