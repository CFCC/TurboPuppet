#
# Install custom CA certificates.
#
class profiles::tls::certificates {
  # Match profiles::cfcc::filesystem CampFitch root on POSIX.
  $fs_root = $facts['kernel'] ? {
    'windows' => 'C:/CampFitch',
    default   => '/opt/CampFitch',
  }

  $local_cert_directory = $facts['os']['family'] ? {
    'windows'           => "${fs_root}/usr/share/certificates",
    'Darwin'            => "${fs_root}/usr/share/certificates",
    default             => '/etc/pki/ca-trust/source/anchors',
  }

  file { $local_cert_directory:
    ensure  => 'directory',
    source  => 'puppet:///modules/cfcc/certificates',
    recurse => 'remote',
    purge   => false,
    replace => false,
  }

  case $facts['os']['family'] {
    'windows': {
      # CA = Current User or Local Computer \ Intermediate Certification Authorities \ Certificates
      # Root = Current User or Local Computer \ Trusted Root Certification Authorities \ Certificates

      # Thumbprints can be generated with:
      # openssl x509 -in path/to/file.pem -noout -fingerprint -sha1

      Sslcertificate {
        location   => $local_cert_directory,
        root_store => 'LocalMachine',
        store_dir  => 'Root',
      }

      sslcertificate { 'UniFi-SSL-Certificate.cer':
        thumbprint => '3BC62B1E77A9B4886FC9F7021655128A90E8E1D5',
      }
    }
    'Darwin': {
      # Files from puppet:/// land in staging; promote to System keychain.
      # Must mirror cfcc/files/certificates/* for idempotent exec naming.
      $darwin_cert_basenames = [
        'UniFi-SSL-Certificate.cer',
      ]
      $darwin_cert_basenames.each |String $certfile| {
        $cert_path = "${local_cert_directory}/${certfile}"
        exec { "Darwin trust-root ${certfile}":
          command => "/usr/bin/security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain '${cert_path}'",
          unless  => "/usr/bin/security verify-cert -p ssl -c '${cert_path}' 2>/dev/null",
          onlyif  => "/bin/test -f '${cert_path}'",
          require => File[$local_cert_directory],
        }
      }
    }
    'Linux', 'RedHat': {
      # @TODO exec { 'update-ca-trust': subscribe => File[$local_cert_directory], ... }
    }
    default: {
      warning("profiles::tls::certificates: trust-import not implemented for ${facts['os']['family']} — certificates staged at ${local_cert_directory}")
    }
  }
}
