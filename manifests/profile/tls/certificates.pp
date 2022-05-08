#
#
#
class profile::tls::certificates {

  $certificate_files = [
    'tars-ca-v1.crt',
    'tars-ca-v2.crt',
  ]

  $local_cert_directory = $::kernel ? {
    'windows' => 'C:/CampFitch/usr/share/certificates',
    default   => '/etc/pki/ca-trust/source/anchors'
  }

  $certificate_files.each |String $cert| {
    file { $cert:
      ensure => present,
      path   => "${local_cert_directory}/${cert}",
      source => "puppet:///modules/cfcc/certificates/${cert}"
    }
  }
  case $::operatingsystem {
    'windows': {
    }
    default: {}
  }
}
