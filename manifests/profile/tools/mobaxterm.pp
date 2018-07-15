#
# MobaXterm
#
class profile::tools::mobaxterm {
    $package_name = $::osfamily ? {
        'windows' => 'mobaxterm',
        default   => fail('Unsupported OS')
    }
    package { $package_name: }

    file { 'MobaXtermConfigDir':
        path   => "C:/Users/${turbosite::camper_username}/Documents/MobaXterm/",
        ensure => directory,
        owner  => $turbosite::camper_username
    }

    # There is a section of title "[WindowPos_CFCCZOTAC04_1_1710]" that controls
    # the last viewed window postion, most importantly "SidebarVisible=0".
    # Unfortunately it is keyed off of the hostname and current screen resolution.
    # @TODO Test for if .upcase is needed on hostname
    file { 'MobaXterm.ini':
        path    => "C:/Users/${turbosite::camper_username}/Documents/MobaXterm/MobaXterm.ini",
        ensure  => present,
        replace => no,
        content => template('cfcc/mobaxterm/MobaXterm.ini.erb'),
        owner   => $turbosite::camper_username
    }

    File['MobaXtermConfigDir'] -> File['MobaXterm.ini']
}