#
# Windows Assissment and Deployment Kit
#
class profiles::tool::adk {
  package { ['windows-adk', 'windows-adk-winpe']: }
}
