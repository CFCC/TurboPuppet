#
#
#
class profile::tls::certificates {

  $local_cert_directory = $::kernel ? {
    'windows' => 'C:/CampFitch/usr/share/certificates',
    default   => '/etc/pki/ca-trust/source/anchors'
  }

  file { $local_cert_directory:
    ensure  => 'directory',
    source  => 'puppet:///modules/cfcc/certificates',
    recurse => 'remote',
    purge   => false,
    replace => false,
  }

  case $::kernel {
    'windows': {
      # CA = Current User or Local Computer \ Intermediate Certification Authorities \ Certificates
      # Root = Current User or Local Computer \ Trusted Root Certification Authorities \ Certificates
      Sslcertificate {
        location   => $local_cert_directory,
        root_store => 'LocalMachine',
        store_dir  => 'Root',
      }

      sslcertificate { "tars-ca-v1.crt":
        thumbprint => 'B4AB05D2F7C362411E9118EA08DE991FEA3A391E'
      }

      sslcertificate { "tars-ca-v2.crt":
        thumbprint => '1F30886A00CEA39B8D167A244F2712C5050ED429'
      }
    }
    'Linux': {
      # In theory this should just contain an exec{updatecatrust} and a conditional
      # notify on the directory. Life is easy.
    }
  }
}
