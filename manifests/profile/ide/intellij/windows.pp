#
#
#
class profile::ide::intellij::windows {

    $intellij_version = $::profile::ide::intellij::version

    shortcut { "C:\\Users\\Public\\Desktop\\IntelliJ IDEA Community Edition ${intellij_version}.lnk":
        target => "C:\\Program Files (x86)\\JetBrains\IntelliJ IDEA Community Edition ${intellij_version}\\bin\\idea64.exe"
    }

    # @TODO maybe figure out a way to auto-detect the installed JDK so that we don't have to set it manually.
}