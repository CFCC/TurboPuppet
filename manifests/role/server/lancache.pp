#
#
#
# @TODO inherit role::server
class role::server::lancache inherits role::server {
  include profile::lancache::web::nginx
  include profile::lancache::web::sniproxy
  include profile::lancache::dns
}
