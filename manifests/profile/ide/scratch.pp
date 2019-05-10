#
# MIT Scratch
#
class profile::ide::scratch {
    # Since this is a webapp, we'll simply create a desktop shortcut to make
    # finding it easier.

    case $::osfamily {
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
        default: { fail('Unsupported OS') }
    }

}
