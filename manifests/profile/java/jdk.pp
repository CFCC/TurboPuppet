#
# JDK
#
class profile::java::jdk {
    $runtime_package_name = $::osfamily ? {
        'windows' => 'jdk11',
        'Darwin'  => 'oracle-jdk',
        default   => fail('Unsupported OS')
    }

    package { $runtime_package_name: }
}