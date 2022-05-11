#
# Windows Assissment and Deployment Kit
#
class profile::tool::adk {
  package { ['windows-adk', 'windows-adk-winpe']: }
}
