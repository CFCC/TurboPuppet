#
# Git
#
class profile::tools::git {
    package { 'git': }

    case $::osfamily {
        'windows': {
            package { 'github-desktop':
                notify => Exec['kill github-desktop app']
            }

            # Github Desktop assumes that you instantly want to log in
            # when you install. We don't. Go away.
            exec { 'kill github-desktop app':
                command     => 'Sleep 10; Stop-Process -ProcessName GithubDesktop',
                refreshonly => true
            }
        }
        default: { }
    }
}