#
# CCleaner cleanup tool
#
class profile::tools::ccleaner {
    $package_name = $::osfamily ? {
        'windows' => 'ccleaner',
        default   => fail('Unsupported OS')
    }

    package { $package_name: }

    # Scheduled runs cost $$$ :(
}