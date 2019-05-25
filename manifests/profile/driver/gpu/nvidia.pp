#
#
#
class profile::driver::gpu::nvidia {

    case $::operatingsystem {
        'windows': {
            # There is some bad juju with the nvidia drivers and the
            # EN1070, EN1070K, and EN1080K series.
            #
            # Prerequisite reading:
            # https://www.techpowerup.com/250415/psa-nvidia-installer-cannot-continue-on-windows-october-2018-update-and-how-to-fix-it
            #
            # EN1070 (non-K):
            #   As of 20190521: the stock Windows driver from Windows Update (1809)
            #   doesn't seem to have proper 3D support. Still full resolution
            #   but is missing a lot of things. Installing 430.64 from NVIDIA
            #   caused the host to panic when unplugging a monitor. It would then
            #   continue to panic in a loop until eventually Windows stops
            #   booting to ask what you want to do. Only reason I know this is
            #   what it does is because I've seen it before. You can't actually
            #   connect a display after the fact. It HAS to be connected when you
            #   boot the system. When it has a display connected everything is
            #   fine. I ran the Display Driver Uninstaller (DDU) tool
            #   to clean and restart. That seemed to take care of the boot loop
            #   and panic upon display disconnection. However you still can't
            #   attach a display after you boot. I suspect it may be related to
            #   the weirdness in the TechPowerUp article.
            #
            # EN1070K:
            #   Windows Update applies the default version from Windows Update
            #   (22.21.13.8205, not sure what this means in terms of NVIDIA
            #   release). Device Manager reports it cant start the device and
            #   the resolution is super low. Installing the 430.64 from NVIDIA
            #   works just fine. Unlike the EN1070 non-K's, you can connect a
            #   monitor after boot.
            #
            # EN1080K:
            #   Haven't gotten here yet.

            package { 'nvidia-display-driver': }
            package { 'ddu': }
        }
        default: {}
    }

}