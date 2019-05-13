#
# Here we define very common packages. If we were to define these
# resources in every profile that called on them odds are we'd end
# up with conflicts. For example:
#   Lets say a backup script and the Fortnite installer
#   both require rsync. If I do package { 'rysync': } in
#   each of their respective profiles I will get a
#   duplicate declaraction error from Puppet.
# With the voodoo of Virtual Resource we can "realize" the same
# definition multiple times and only declare the package once!
# See also: yumrepos
#
class profile::packaging::packages {
    @package { 'rsync': }
}