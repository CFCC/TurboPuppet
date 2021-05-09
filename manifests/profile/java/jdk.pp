#
# JDK
#
class profile::java::jdk {
  $runtime_package_name = $::operatingsystem ? {
    'windows' => 'jdk11',
    'Darwin'  => 'oracle-jdk',
    'Fedora'  => 'java-11-openjdk',
    default   => fail('Unsupported OS')
  }

  package { $runtime_package_name: }
}
