#
#
#
class roles::camper::java {
    include profiles::java::jdk8
    include profiles::ide::intellij

    Class['profiles::java::jdk8'] -> Class['profiles::ide::intellij']
}