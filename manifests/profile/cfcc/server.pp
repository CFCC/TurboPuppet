#
# Common things that define a server machine.
#
class profile::cfcc::server {
    # https://yum.puppet.com/puppet5/puppet5-release-el-7.noarch.rpm
    # puppet-agent
    # reload profile
    # cifs-utils
    # rsync
    include profile::puppet::agent::disable
}