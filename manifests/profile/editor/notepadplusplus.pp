#
# Notepad++ Editor
#
class profile::editor::notepadplusplus {
  $package_name = $::operatingsystem ? {
    'windows' => 'notepadplusplus',
    default   => fail('Unsupported OS')
  }
  package { $package_name: }
}
