#
#
#
class roles::camper::linux {
    # This is where we specify defaults that automatically apply to ALL
    # package{} resources in child classes. These can be overridden
    # as needed.
    Package {
        ensure => present
    }

    fail("We might support Linux someday. That day is not today.")
}