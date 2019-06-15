#
#
#
class profile::windows::wsl {
    package { 'wsl': } ->
    package { 'wsl-ubuntu-1804': }

    # @TODO
    # * %PROGRAMDATA%\Choco\lib\tools\wsl-ubuntu\ubuntu1804.exe --default-user root|camper
    # * useradd --create-home -g admin campoer -p HASH
    # * icon/shortcut (start in C:\)
}