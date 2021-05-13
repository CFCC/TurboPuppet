#
#
#
class profile::windows::wsl {
  # package { 'wsl2': }
  # wsl-ubuntu-2004 needs package wsl2 to be installed first and either a shell
  # refresh or reboot before the first can be installed. Figure out a way to do that.
  # package { 'wsl-ubuntu-2004': }

  # @TODO
  # * %PROGRAMDATA%\Choco\lib\tools\wsl-ubuntu\ubuntu1804.exe --default-user root|camper
  # * useradd --create-home -g admin camper -p HASH
  # * icon/shortcut (start in C:\)
}