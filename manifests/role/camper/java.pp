#
# A few of Jordans favorite things!
#
class role::camper::java inherits role::camper {
    include profile::java::jdk
    include profile::ide::intellij

    Class['profile::java::jdk'] -> Class['profile::ide::intellij']
}