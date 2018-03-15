#
#
#
class roles::camper::web {
  include profiles::base
  include profiles::cfcc::camper
  include profiles::browsers::chrome
  include profiles::browsers::firefox

  Class['profiles::base'] -> Class['profiles::browsers::chrome']
  Class['profiles::base'] -> Class['profiles::browsers::firefox']
}
