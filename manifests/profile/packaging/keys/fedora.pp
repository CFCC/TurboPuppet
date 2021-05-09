#
#
#
class profile::packaging::keys::fedora {
  # System
  # Fedora ships the base keys with the OS, so we will trust those for now and not enforce
  # them here.

  # Collections
  # Because RPMFusion is a bit more complex, rather than installing the key files I drop
  # in their dist RPM instead. They provide a whole bunch of keys in that. The initial .repo
  # files that it installs in /etc/yum.repos.d will get overwritten in other resources here
  # anyway.
  #
  # This really isn't the proper way to do this because those keys can change out on you.
  # However, it's not just as simple as:
  # file { 'rpmfusionkey'
  #     source => 'url'
  # }
  # They do some funky user-agent-specific crap to prevent that. It's stupid, so we
  # must deal with it.
  package { "rpmfusion-free-${::operatingsystemmajrelease}":
    name   => 'rpmfusion-free-release',
    source => "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-${::operatingsystemmajrelease}.noarch.rpm",
    ensure => present
  }
  package { "rpmfusion-nonfree-${::operatingsystemmajrelease}":
    name   => 'rpmfusion-nonfree-release',
    source => "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${::operatingsystemmajrelease}.noarch.rpm",
    ensure => present
  }

  # ThirdParty
  file { "RPM-GPG-KEY-copr_phracek-pycharm":
    source => "puppet:///campfs/rpm-gpg/RPM-GPG-KEY-copr_phracek-pycharm",
    path   => "/etc/pki/rpm-gpg/RPM-GPG-KEY-copr_phracek-pycharm"
  }

  file { "RPM-GPG-KEY-copr_lkiesow-intellij-idea-community":
    source => "puppet:///campfs/rpm-gpg/RPM-GPG-KEY-copr_lkiesow-intellij-idea-community",
    path   => "/etc/pki/rpm-gpg/RPM-GPG-KEY-copr_lkiesow-intellij-idea-community"
  }

  file { "RPM-GPG-KEY-copr_elken-gitkraken":
    source => "puppet:///campfs/rpm-gpg/RPM-GPG-KEY-copr_elken-gitkraken",
    path   => "/etc/pki/rpm-gpg/RPM-GPG-KEY-copr_elken-gitkraken"
  }

  file { "RPM-GPG-KEY-google-chrome":
    source => "puppet:///campfs/rpm-gpg/RPM-GPG-KEY-google-chrome",
    path   => "/etc/pki/rpm-gpg/RPM-GPG-KEY-google-chrome"
  }

  file { "RPM-GPG-KEY-puppet":
    source => "puppet:///campfs/rpm-gpg/RPM-GPG-KEY-puppet",
    path   => "/etc/pki/rpm-gpg/RPM-GPG-KEY-puppet"
  }

  file { "RPM-GPG-KEY-sublime-text":
    source => "puppet:///campfs/rpm-gpg/RPM-GPG-KEY-sublime-text",
    path   => "/etc/pki/rpm-gpg/RPM-GPG-KEY-sublime-text"
  }

  # This is an unfixed bug in Puppet where you cannot HEAD against an S3 repo, thus making
  # requests to packagecloud.io resources doesn't work with the File{} resource.
  # See https://tickets.puppetlabs.com/browse/PUP-8300 for details.
  # We hack around this by manually calling Curl for the key. Note that this will not
  # update the file once it is created.
  # exec { "RPM-GPG-KEY-slack":
  #     command => '/usr/bin/curl -sL -o /etc/pki/rpm-gpg/RPM-GPG-KEY-slack https://packagecloud.io/slacktechnologies/slack/gpgkey',
  #     creates => '/etc/pki/rpm-gpg/RPM-GPG-KEY-slack'
  # }
  #
  # After all the effort into doing the above, turns out Slack just doesn't have their
  # proper distro key in Packagecloud. But it is on their website! Software suxx.
  # By the way: `rpm -qpi /path/to/package.rpm` will show the signature of the signer,
  # which you can punch into Google to find said key.
  #
  # Well, it's not so simple. The Slack key at https://slack.com/gpg/slack_pubkey.gpg
  # is served from Cloudfront, which I think is causing some weirdness with the
  # Puppet File{} resource's https source. It keeps re-downloading every time even if
  # the content or mtime don't change. Seems to be a sorta known thing?
  # https://tickets.puppetlabs.com/browse/PUP-1072
  # Regardless, I'm gonna have to be a good person and jam them into the Puppet
  # filesystem.
  file { "RPM-GPG-KEY-slack":
    source => "puppet:///campfs/rpm-gpg/RPM-GPG-KEY-slack",
    path   => "/etc/pki/rpm-gpg/RPM-GPG-KEY-slack",
  }
}
