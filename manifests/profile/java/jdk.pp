#
# JDK
#
class profile::java::jdk {
    $runtime_package_name = $::osfamily ? {
        'windows' => 'jdk10',
        default   => fail('Unsupported OS')
    }

    package { $runtime_package_name: }
}