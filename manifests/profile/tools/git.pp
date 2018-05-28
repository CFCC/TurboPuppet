#
# Git
#
class profile::tools::git {
    package { 'git': }

    case $::kernel {
        'windows': {
            package { 'github-desktop':
                notify => Exec['kill github-desktop app']
            }

            # Github Desktop assumes that you instantly want to log in
            # when you install. We don't. Go away.
            exec { 'kill github-desktop app':
                command     => 'Sleep 15; Stop-Process -ProcessName GithubDesktop',
                refreshonly => true
            }
        }
        'Linux': {
            # @TODO git desktop
        }
        default: { }
    }
}