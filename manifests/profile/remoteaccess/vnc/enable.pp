#
# VNC - Enable
#
class profile::remoteaccess::vnc::enable {
  case $::operatingsystem {
    'windows': {
      package { 'tightvnc': }

      # @TODO do real encryption on this. vncpasswd not good enough.
      registry_value { 'TightVNCPassword':
        path    => 'HKLM\SOFTWARE\TightVNC\Server\Password',
        type    => 'binary',
        data    => '1243cb10f4dbaa68',
        require => Package['tightvnc'],
        notify  => Service['tvnserver']
      }

      service { 'tvnserver':
        ensure  => 'running',
        enable  => true,
        require => Package['tightvnc']
      }
    }
    default: { fail('Unsupported OS') }
  }
}