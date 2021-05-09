#
# SublimeText Editor
#
class profile::editor::atom {
  $package_name = $::operatingsystem ? {
    'windows' => 'atom',
    default   => fail('Unsupported OS')
  }
  package { $package_name: }
}
