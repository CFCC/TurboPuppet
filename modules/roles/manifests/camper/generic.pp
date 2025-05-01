#
# Generic camper PC. All the things.
#
class roles::camper::generic inherits roles::camper {
  # Intro
  include profiles::ide::scratch

  # Java
  include profiles::java::jdk
  include profiles::ide::intellij
  Class['profiles::java::jdk'] -> Class['profiles::ide::intellij']

  # Photostuffs
  include profiles::editor::gimp

  # Pyle
  include profiles::python::python3
  include profiles::python::turtle
  include profiles::ide::pycharm
  include profiles::ide::vscode
  Class['profiles::python::python3'] -> Class['profiles::ide::pycharm']

  # Game Engine
  include profiles::engine::godot

  # Webz
  include profiles::nodejs::runtime
  case $facts['os']['family'] {
    'windows': {
      include profiles::webserver::xampp
    }
    'Darwin': {
      # Web sharing is already a thing
    }
    'Fedora': {
      # @TODO include profiles::webserver::apache
    }
    default: {
      fail('Unsupported OS')
    }
  }
}
