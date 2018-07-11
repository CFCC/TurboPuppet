#
#
#
class profile::powershell::executionpolicy::unrestricted {
    $scope = 'LocalMachine'
    $policy = 'Unrestricted'

    exec { 'SetExecutionPolicy':
        command  => "Set-ExecutionPolicy -Scope ${scope} -ExecutionPolicy ${policy}",
        onlyif   => psexpr("(Get-ExecutionPolicy -Scope ${scope}) -ne '${policy}'"),
    }
}
