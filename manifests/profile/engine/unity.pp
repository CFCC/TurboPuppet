#
# Unity game engine
#
class profile::engine::unity {
  package { 'unity': }
  package { 'unity-hub': }
  package { 'unity-standard-assets': }
}
