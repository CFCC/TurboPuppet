#
#
#
class profile::ide::pycharm::windows {

    $pycharm_version = $::profile::ide::pycharm::pycharm_version

    shortcut { "C:/Users/Public/Desktop/PyCharm Community Edition ${pycharm_version}.lnk":
        target => "C:/Program Files (x86)/JetBrains/PyCharm Community Edition ${pycharm_version}/bin/pycharm64.exe"
    }
}