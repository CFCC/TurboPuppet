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
    @yumrepo { '_copr_lkiesow-intellij-idea-community':
        descr   => 'Copr repo for intellij-idea-community owned by lkiesow',
        baseurl => 'https://copr-be.cloud.fedoraproject.org/results/lkiesow/intellij-idea-community/fedora-$releasever-$basearch/',
        gpgkey  => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-copr_lkiesow-intellij-idea-community',
    }

    # @TODO https://release.gitkraken.com/linux/gitkraken-amd64.rpm
    # https://release.gitkraken.com/linux/gitkraken-amd64.rpm
    # @yumrepo { '_copr_elken-gitkraken':
    #     descr   => 'Copr repo for gitkraken owned by elken',
    #     baseurl => 'https://copr-be.cloud.fedoraproject.org/results/elken/gitkraken/fedora-$releasever-$basearch/',
    #     gpgkey  => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-copr_elken-gitkraken',
    # }

    @yumrepo { 'google-chrome':
        descr   => 'google-chrome',
        baseurl => 'http://dl.google.com/linux/chrome/rpm/stable/x86_64',
        gpgkey  => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-google-chrome',
    }

    # @TODO fc30 not yet supported :(
    @yumrepo { 'puppet6':
        descr   => 'Puppet 6 Repository fedora 29 - $basearch',
        baseurl => 'http://yum.puppetlabs.com/puppet6/fedora/29/$basearch',
        gpgkey  => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppet',
    }

    @yumrepo { 'rpmfusion-nonfree-nvidia-driver':
        descr   => 'RPM Fusion for Fedora $releasever - Nonfree - NVIDIA Driver',
        baseurl => 'http://download1.rpmfusion.org/nonfree/fedora/nvidia-driver/$releasever/$basearch/',
        # metalink => 'https://mirrors.rpmfusion.org/metalink?repo=nonfree-fedora-nvidia-driver-$releasever&arch=$basearch',
        gpgkey  => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-nonfree-fedora-$releasever',
    }

    @yumrepo { 'rpmfusion-nonfree-steam':
        descr   => 'RPM Fusion for Fedora $releasever - Nonfree - Steam',
        # metalink => 'https://mirrors.rpmfusion.org/metalink?repo=nonfree-fedora-steam-$releasever&arch=$basearch',
        baseurl => 'http://download1.rpmfusion.org/nonfree/fedora/steam/$releasever/$basearch/',
        gpgkey  => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-nonfree-fedora-$releasever'
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
