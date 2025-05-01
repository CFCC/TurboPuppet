#
# Unity game engine
#
class profiles::engine::unity {
  package { 'unity': }
  package { 'unity-hub': }
  package { 'unity-standard-assets': }
}
