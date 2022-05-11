#
# @TODO make this outside of camper
#
class role::camper::mediacenter inherits role::camper {
  include profile::cfcc::mediacenter
  include profile::driver::zotac
  include profile::tool::adk
}
