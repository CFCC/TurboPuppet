#
# MIT Scratch
#
class profile::ide::scratch {
    # Since this is a webapp, we'll simply create a desktop shortcut to make
    # finding it easier.

    case $::operatingsystem {
        'windows': {
            file { 'scratch icon':
                path   => 'C:\ProgramData\scratch.ico',
                ensure => file,
                source => 'https://scratch.mit.edu/favicon.ico',
            }

            # Specifying an icon causes this to change every time :(
            shortcut { 'C:/Users/Public/Desktop/Scratch.lnk':
                icon_location => 'C:\ProgramData\scratch.ico',
                require       => [ Class['profile::browser::chrome'], File['scratch icon'] ],
                target        => 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe',
                arguments     => 'https://scratch.mit.edu'
            }
        }
        'Darwin': {
            # the package is broken with a bad checksum on Adobe-AIR
            #package { 'scratch': }
            # Can't just copy a file because it doesnt have the
            # secret Mac attributes.
        }
        'Fedora': {
            file { 'scratch icon':
                path   => '/usr/share/icons/hicolor/32x32/apps/scratch.ico',
                ensure => file,
                source => 'https://scratch.mit.edu/favicon.ico',
            } ->
            exec { 'convert scratch icon to png':
                command => '/usr/bin/convert scratch.ico scratch.png',
                path    => '/usr/share/icons/hicolor/32x32/apps/',
                creates => '/usr/share/icons/hicolor/32x32/apps/scratch.png',
                notify  => Exec['refresh icon cache']
            } ->
            freedesktop::shortcut { 'Scratch':
                exec       => 'google-chrome https://scratch.mit.edu',
                comment    => 'Scratch',
                icon       => 'scratch'
            }

            # This only runs if called on
            exec { 'refresh icon cache':
                refreshonly => true,
                command     => '/usr/bin/gtk-update-icon-cache /usr/share/icons/hicolor/'
            }
        }
        default: { fail('Unsupported OS') }
    }

}
