#
#
#
class roles::camper::web {
    include profiles::base
    include profiles::cfcc::camper

    include profiles::browsers::chrome
    include profiles::browsers::firefox
    include profiles::ide::pycharm

    Class['profiles::base'] -> Class['profiles::cfcc::camper']
    Class['profiles::cfcc::camper'] -> Class['profiles::browsers::chrome']
    Class['profiles::cfcc::camper'] -> Class['profiles::browsers::firefox']
    Class['profiles::cfcc::camper'] -> Class['profiles::ide::pycharm']
}