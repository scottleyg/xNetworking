$TestTeam = [PSObject]@{
    Name                    = 'TestTeam'
    Members                 =  (Get-NetAdapter -Physical).Name
    loadBalancingAlgorithm  = 'Dynamic'
    teamingMode             = 'SwitchIndependent'
    Ensure                  = 'Present'
}

$TestInterface = [PSObject]@{
    Name                    = 'TestInterface'
    TeamName                = $TestTeam.Name
    VlanID                  = 100
    Ensure                  = 'Present'
}

configuration MSFT_xNetworkTeamInterface_Config
{
    param
    (
        [string[]]$NodeName = 'localhost'
    )

    Import-DSCResource -ModuleName xNetworking

    Node $NodeName
    {
        xNetworkTeam HostTeam
        {
          Name = $TestTeam.Name
          TeamingMode = $TestTeam.teamingMode
          LoadBalancingAlgorithm = $TestTeam.loadBalancingAlgorithm
          TeamMembers = $TestTeam.Members
          Ensure = $TestTeam.Ensure
        }
        
        xNetworkTeamInterface LbfoInterface
        {
          Name = $TestInterface.Name
          TeamName = $TestInterface.TeamName
          VlanID = $TestInterface.VlanID
          Ensure = $TestInterface.Ensure
          DependsOn = '[xNetworkTeam]HostTeam'
        }
    }
}
