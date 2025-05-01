#
# JDK
# AdoptOpenJDK is dead. Base openjdk is too barebones. All hail AWS Corretto?
#
# @param package_name The name of the package to install.
#
class profiles::java::jdk (
  String $package_name,
) {
  package { $package_name: }
}
