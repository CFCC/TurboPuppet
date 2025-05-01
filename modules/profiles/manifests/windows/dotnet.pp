#
# .NET Core SDK
#
class profiles::windows::dotnet {
  # As of 2021-05-11 this was 5.0.5
  # As of 2025-04-30 this is 9.0.4
  package { 'dotnet': }
}
