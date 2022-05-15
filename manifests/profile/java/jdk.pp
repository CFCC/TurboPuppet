#
# JDK
# AdoptOpenJDK is dead. Base openjdk is too barebones. All hail AWS Corretto?
#
class profile::java::jdk {
  $runtime_package_name = $::operatingsystem ? {
    'windows' => 'corretto17jdk',
    'Fedora'  => 'java-17-amazon-corretto-devel',
    default   => fail('Unsupported OS')
  }

  package { $runtime_package_name: }
}
