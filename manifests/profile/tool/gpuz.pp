#
# GPU-Z
#
class profile::tool::gpuz {
  package { 'gpu-z': }

  # @TODO dont install system-wide (standalone mode)
}