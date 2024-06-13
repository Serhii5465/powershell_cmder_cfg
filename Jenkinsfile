@Library(['PrepEnvForBuild', 'DeployWinAgents']) _

node('master') {
    def raw = libraryResource 'configs/powershell_cmder_cfg_repo.json'
    def config = readJSON text: raw
    DeployArtifactsPipelineWinAgents(config)
}