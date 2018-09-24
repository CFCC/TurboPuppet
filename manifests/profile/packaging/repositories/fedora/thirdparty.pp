#
#
#
class profile::packaging::repositories::fedora::thirdparty {

    Yumrepo {
        tag                 => ['yumrepo-thirdparty'],
        skip_if_unavailable => true,
        enabled             => 1,
        gpgcheck            => 1,
        repo_gpgcheck       => 0,
        ensure              => present,
    }

    @yumrepo { '_copr_phracek-PyCharm':
        descr   => 'Copr repo for PyCharm owned by phracek',
        baseurl => 'https://copr-be.cloud.fedoraproject.org/results/phracek/PyCharm/fedora-$releasever-$basearch/',
        gpgkey  => 'https://copr-be.cloud.fedoraproject.org/results/phracek/PyCharm/pubkey.gpg',
    }

    @yumrepo { 'google-chrome':
        descr   => 'google-chrome',
        baseurl => 'http://dl.google.com/linux/chrome/rpm/stable/x86_64',
        gpgkey  => 'https://dl.google.com/linux/linux_signing_key.pub',
    }

    @yumrepo { 'puppet5':
        descr   => 'Puppet 5 Repository fedora 28 - $basearch',
        baseurl => 'http://yum.puppetlabs.com/puppet5/fedora/$releasever/$basearch',
        gpgkey  => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppet5-release',
    }

    @yumrepo { 'rpmfusion-nonfree-nvidia-driver':
        descr   => 'RPM Fusion for Fedora $releasever - Nonfree - NVIDIA Driver',
        # baseurl => 'http://download1.rpmfusion.org/nonfree/fedora/nvidia-driver/$releasever/$basearch/',
        metalink => 'https://mirrors.rpmfusion.org/metalink?repo=nonfree-fedora-nvidia-driver-$releasever&arch=$basearch',
        gpgkey  =>
            'file:///usr/share/distribution-gpg-keys/rpmfusion/RPM-GPG-KEY-rpmfusion-nonfree-fedora-$releasever',

    }

    @yumrepo { 'rpmfusion-nonfree-steam':
        descr    => 'RPM Fusion for Fedora $releasever - Nonfree - Steam',
        metalink => 'https://mirrors.rpmfusion.org/metalink?repo=nonfree-fedora-steam-$releasever&arch=$basearch',
        gpgkey   => 'file:///usr/share/distribution-gpg-keys/rpmfusion/RPM-GPG-KEY-rpmfusion-nonfree-fedora-$releasever'
    }

    @yumrepo { 'sublime-text':
        descr   => 'Sublime Text - x86_64 - Stable',
        baseurl => 'https://download.sublimetext.com/rpm/stable/x86_64',
        gpgkey  => 'https://download.sublimetext.com/sublimehq-rpm-pub.gpg',
    }
}
