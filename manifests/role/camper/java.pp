#
# A few of Jordans favorite things!
#
class role::camper::java inherits role::camper::base {

    include profile::java::jdk8
    include profile::ide::intellij

    Class['profile::java::jdk8'] -> Class['profile::ide::intellij']
}