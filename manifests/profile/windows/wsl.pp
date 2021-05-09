#
#
#
class profile::windows::wsl {
  package { 'wsl2': } ->
  package { 'wsl-ubuntu-2004': }

  # @TODO
  # * %PROGRAMDATA%\Choco\lib\tools\wsl-ubuntu\ubuntu1804.exe --default-user root|camper
  # * useradd --create-home -g admin camper -p HASH
  # * icon/shortcut (start in C:\)
}