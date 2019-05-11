#
# A few of Jordans favorite things!
#
class role::cfcc::camper::java inherits role::cfcc::camper {
    include profile::java::jdk
    include profile::ide::intellij

    Class['profile::java::jdk'] -> Class['profile::ide::intellij']
}