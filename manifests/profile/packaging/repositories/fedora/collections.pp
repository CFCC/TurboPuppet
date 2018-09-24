#
#
#
class profile::packaging::repositories::fedora::collections {

    Yumrepo {
        tag                 => ['yumrepo-collections'],
        skip_if_unavailable => true,
        enabled             => 1,
        gpgcheck            => 1,
        repo_gpgcheck       => 0,
        ensure              => present,
    }

    # 3rd Party Collections "Supported"
    @yumrepo { 'rpmfusion-nonfree':
        descr           => 'RPM Fusion for Fedora $releasever - Nonfree',
        #baseurl         => 'http://download1.rpmfusion.org/nonfree/fedora/releases/$releasever/Everything/$basearch/os/',
        metalink        => 'https://mirrors.rpmfusion.org/metalink?repo=nonfree-fedora-$releasever&arch=$basearch',
        metadata_expire => '14d',
        gpgkey          => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-nonfree-fedora-$releasever',
    }

    @yumrepo { 'rpmfusion-free':
        descr           => 'RPM Fusion for Fedora $releasever - Free',
        # baseurl         => 'http://download1.rpmfusion.org/free/fedora/releases/$releasever/Everything/$basearch/os/',
        metalink        => 'https://mirrors.rpmfusion.org/metalink?repo=free-fedora-$releasever&arch=$basearch',
        metadata_expire => '14d',
        gpgkey          => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-free-fedora-$releasever',
    }

    @yumrepo { 'rpmfusion-nonfree-updates':
        descr    => 'RPM Fusion for Fedora $releasever - Nonfree - Updates',
        # baseurl  => 'http://download1.rpmfusion.org/nonfree/fedora/updates/$releasever/$basearch/',
        metalink =>
            'https://mirrors.rpmfusion.org/metalink?repo=nonfree-fedora-updates-released-$releasever&arch=$basearch',
        gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-nonfree-fedora-$releasever',
    }

    @yumrepo { 'rpmfusion-free-updates':
        descr    => 'RPM Fusion for Fedora $releasever - Free - Updates',
        # baseurl  => 'http://download1.rpmfusion.org/free/fedora/updates/$releasever/$basearch/',
        metalink =>
            'https://mirrors.rpmfusion.org/metalink?repo=free-fedora-updates-released-$releasever&arch=$basearch',
        gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-free-fedora-$releasever',
    }
}
