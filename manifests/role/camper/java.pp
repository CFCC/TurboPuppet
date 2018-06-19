#
# A few of Jordans favorite things!
#
class role::camper::java inherits role::base {
    include site::cfcc
    include profile::cfcc::camper
    include profile::access::camper

    Class['site::cfcc'] -> Class['profile::cfcc::camper']
    Class['site::cfcc'] -> Class['profile::access::camper']

    include profile::java::jdk
    include profile::ide::intellij

    Class['profile::java::jdk'] -> Class['profile::ide::intellij']
}