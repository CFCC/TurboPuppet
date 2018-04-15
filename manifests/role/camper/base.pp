#
# Operating system defaults and common classes for all role.
#
class role::camper::base {
    # The site needs to be at the top. There should only be one site.
    include site::cfcc

    # Platform base
    case $::osfamily {
        'windows': {
            # This is where we specify defaults that automatically apply to ALL
            # package{} resources in child classes. These can be overridden
            # as needed.
            #
            # Windows requires the provider to be explicitly stated.

            include profile::packaging::chocolatey
            # @TODO someday this may need to be a generic profile::powershell
            include profile::powershell::executionpolicy::unrestricted

            Package {
                provider => chocolatey,
                ensure   => present
            }
            Exec {
                provider => powershell
            }

            include profile::base::windows

            Class['site::cfcc'] -> Class['profile::base::windows']
            Class['profile::base::windows'] -> Class['profile::cfcc::camper']
            Class['profile::base::windows'] -> Class['profile::access::camper']
        }
        default: {
            fail("platform is unsupported")
        }
    }

    # Other includes at the bottom
    include profile::cfcc::camper
    include profile::access::camper
}
