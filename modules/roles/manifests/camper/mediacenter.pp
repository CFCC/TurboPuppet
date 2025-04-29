#
# @TODO make this outside of camper
#
class roles::camper::mediacenter inherits roles::camper {
  include profiles::cfcc::mediacenter
  include profiles::driver::zotac
  include profiles::tool::adk
}
