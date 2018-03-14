#
#
#
class roles::camper::web {
  include profiles::base
  include profiles::cfcc::camper
  include profiles::browser::chrome
}