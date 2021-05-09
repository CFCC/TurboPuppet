#
#
#
class profile::power::alwayson::linux {
  Dconf::Setting {
    user => $::turbosite::camper_username,
    uid  => $::turbosite::camper_uid
  }

  dconf::setting { 'lock-enabled':
    key   => '/org/cinnamon/desktop/screensaver/lock-enabled',
    value => false,
  }

  dconf::setting { 'sleep-display-ac':
    key   => '/org/cinnamon/settings-daemon/plugins/power/sleep-display-ac',
    value => 0,
  }

  dconf::setting { 'sleep-display-battery':
    key   => '/org/cinnamon/settings-daemon/plugins/power/sleep-display-battery',
    value => 1800,
  }

  dconf::setting { 'power-button':
    key   => '/org/cinnamon/settings-daemon/plugins/power/button-power',
    value => 'shutdown',
  }

  dconf::setting { 'lock-on-suspend':
    key   => '/org/cinnamon/settings-daemon/plugins/power/lock-on-suspend',
    value => false,
  }

}
