#
# VNC - Enable
#
class profiles::remoteaccess::vnc::enable {
  case $facts['os']['family'] {
    'windows': {
      package { 'tightvnc': }

      Registry_value {
        require => Package['tightvnc'],
        notify  => Service['tvnserver'],
      }

      # @TODO do real encryption on this. vncpasswd not good enough.
      registry_value { 'TightVNCPassword':
        path => 'HKLM\SOFTWARE\TightVNC\Server\Password',
        type => 'binary',
        data => '1243cb10f4dbaa68',
      }

      registry_value { 'TightVNCWallpaper':
        path => 'HKLM\SOFTWARE\TightVNC\Server\RemoveWallpaper',
        type => 'dword',
        data => 0,
      }

      service { 'tvnserver':
        ensure  => 'running',
        enable  => true,
        require => Package['tightvnc'],
      }
    }
    'Darwin': {
      service { 'com.apple.screensharing':
        ensure   => running,
        enable   => true,
        provider => launchd,
      }
    }
    default: { fail('Unsupported OS') }
  }
}
