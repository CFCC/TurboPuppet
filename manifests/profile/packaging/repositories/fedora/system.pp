#
#
#
class profile::packaging::repositories::fedora::system {

    Yumrepo {
        tag                 => ['yumrepo-system'],
        skip_if_unavailable => false,
        enabled             => 1,
        gpgcheck            => 1,
        repo_gpgcheck       => 0,
        ensure              => present,
    }

    @yumrepo { 'fedora':
        descr           => 'Fedora $releasever - $basearch',
        failovermethod  => 'priority',
        baseurl         => 'http://mirror.rit.edu/fedora/fedora/linux/releases/$releasever/Everything/$basearch/os/',
        #metalink        => 'https://mirrors.fedoraproject.org/metalink?repo=fedora-$releasever&arch=$basearch',
        metadata_expire => '7d',
        gpgkey          => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$releasever-$basearch',
    }

    @yumrepo { 'fedora-modular':
        descr           => 'Fedora Modular $releasever - $basearch',
        failovermethod  => 'priority',
        baseurl         => 'http://mirror.rit.edu/fedora/fedora/linux/releases/$releasever/Modular/$basearch/os/',
        metadata_expire => '7d',
        gpgkey          => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$releasever-$basearch',
    }

    @yumrepo { 'fedora-updates':
        descr           => 'Fedora $releasever - $basearch - Updates',
        failovermethod  => 'priority',
        baseurl         => 'http://mirror.rit.edu/fedora/fedora/linux/updates/$releasever/Everything/$basearch/',
        #metalink        => 'https://mirrors.fedoraproject.org/metalink?repo=updates-released-f$releasever&arch=$basearch',
        metadata_expire => '6h',
        gpgkey          => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$releasever-$basearch',
    }

    @yumrepo { 'fedora-updates-modular':
        descr           => 'Fedora Modular $releasever - $basearch - Updates',
        failovermethod  => 'priority',
        baseurl         => 'http://mirror.rit.edu/fedora/fedora/linux/releases/$releasever/Modular/$basearch/os/',
        metadata_expire => '7d',
        gpgkey          => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$releasever-$basearch',
    }

    # @yumrepo { 'fedora-cisco-openh264':
    #     descr           => 'Fedora $releasever openh264 (From Cisco) - $basearch',
    #     baseurl         => 'https://codecs.fedoraproject.org/openh264/$releasever/$basearch/',
    #     enabled         => 0,
    #     metadata_expire => '14d',
    #     repo_gpgcheck   => 1,
    #     gpgkey          => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$releasever-$basearch',
    # }
}
