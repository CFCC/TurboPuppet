#
#
#
class profiles::powershell::executionpolicy::unrestricted {
  $scope = 'LocalMachine'
  $policy = 'Unrestricted'

  exec { 'SetExecutionPolicy':
    command => "Set-ExecutionPolicy -Scope ${scope} -ExecutionPolicy ${policy}",
    onlyif  => cfcc::psexpr("(Get-ExecutionPolicy -Scope ${scope}) -ne '${policy}'"),
  }
}
