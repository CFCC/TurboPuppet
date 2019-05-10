#
#
#
# @TODO inherit role::server
class role::server::lancache inherits role::base {
    include profile::lancache::web
    include profile::lancache::web::steam

    include profile::lancache::dns

    Class['profile::lancache::web']
    -> Class['profile::lancache::web::steam']
}
