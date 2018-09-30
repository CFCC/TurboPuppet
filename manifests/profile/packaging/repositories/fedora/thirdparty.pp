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
        gpgkey  => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-copr_phracek-pycharm',
    }

    @yumrepo { '_copr_elken-gitkraken':
        descr   => 'Copr repo for gitkraken owned by elken',
        baseurl => 'https://copr-be.cloud.fedoraproject.org/results/elken/gitkraken/fedora-$releasever-$basearch/',
        gpgkey  => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-copr_elken-gitkraken',
    }

    @yumrepo { 'google-chrome':
        descr   => 'google-chrome',
        baseurl => 'http://dl.google.com/linux/chrome/rpm/stable/x86_64',
        gpgkey  => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-google-chrome',
    }

    @yumrepo { 'puppet5':
        descr   => 'Puppet 5 Repository fedora 28 - $basearch',
        baseurl => 'http://yum.puppetlabs.com/puppet5/fedora/$releasever/$basearch',
        gpgkey  => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppet',
    }

    @yumrepo { 'rpmfusion-nonfree-nvidia-driver':
        descr    => 'RPM Fusion for Fedora $releasever - Nonfree - NVIDIA Driver',
        # baseurl => 'http://download1.rpmfusion.org/nonfree/fedora/nvidia-driver/$releasever/$basearch/',
        metalink =>
            'https://mirrors.rpmfusion.org/metalink?repo=nonfree-fedora-nvidia-driver-$releasever&arch=$basearch',
        gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-nonfree-fedora-$releasever',
    }

    @yumrepo { 'rpmfusion-nonfree-steam':
        descr    => 'RPM Fusion for Fedora $releasever - Nonfree - Steam',
        metalink => 'https://mirrors.rpmfusion.org/metalink?repo=nonfree-fedora-steam-$releasever&arch=$basearch',
        gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-nonfree-fedora-$releasever'
    }

    @yumrepo { 'sublime-text':
        descr   => 'Sublime Text - x86_64 - Stable',
        baseurl => 'https://download.sublimetext.com/rpm/stable/x86_64',
        gpgkey  => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-sublime-text',
    }

    @yumrepo { 'slack':
        descr   => 'Slack',
        baseurl => 'https://packagecloud.io/slacktechnologies/slack/fedora/21/$basearch',
        gpgkey  => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-slack',
    }
}
