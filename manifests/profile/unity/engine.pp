#
# Unity game engine
#
class profile::unity::engine {
    package { 'unity': }
    package { 'unity-hub': }
    package { 'unity-standard-assets': }
}