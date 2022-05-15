#
# JDK
# AdoptOpenJDK is dead.
#
class profile::java::jdk {
  $runtime_package_name = $::operatingsystem ? {
    'windows' => 'openjdk17',
    # 'Darwin'  => 'oracle-jdk',
    'Fedora'  => 'java-17-openjdk',
    default   => fail('Unsupported OS')
  }

  package { $runtime_package_name: }
}
