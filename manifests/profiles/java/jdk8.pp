#
# JDK 8
#
class profile::java::jdk8 {
    $runtime_package_name = $::osfamily ? {
        'windows' => 'jdk8',
        default   => fail('Unsupported OS')
    }

    package { $runtime_package_name: }
}