#
# Things to make Puppet work. Packages, basic network connectivity, etc
#
class profiles::base {
    include profiles::packaging
    include profiles::site::cfcc
}