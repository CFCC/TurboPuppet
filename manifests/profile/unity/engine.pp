#
# Unity game engine
#
class profile::unity::engine {
    package { 'unity': }

    package { 'unity-standard-assets': }
}