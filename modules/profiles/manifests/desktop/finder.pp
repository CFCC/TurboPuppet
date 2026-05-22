#
# Tweaks to Finder and the macOS desktop environment.
#
class profiles::desktop::finder {

  Cfcc::Osx_defaults {
    user => lookup('camper_username'),
    type => 'int',
  }

  # Hide widgets from the desktop
  cfcc::osx_defaults { 'WindowManager-StandardHideWidgets':
    domain => 'com.apple.WindowManager',
    key    => 'StandardHideWidgets',
    value  => '1',
  }

  # Click Stage Manager icon to show desktop (not a single click on desktop)
  cfcc::osx_defaults { 'WindowManager-EnableStandardClickToShowDesktop':
    domain => 'com.apple.WindowManager',
    key    => 'EnableStandardClickToShowDesktop',
    type   => 'bool',
    value  => '0',
  }

  # Always show scroll bars
  cfcc::osx_defaults { 'GlobalDomain-AppleShowScrollBars':
    domain => 'Apple Global Domain',
    key    => 'AppleShowScrollBars',
    type   => 'string',
    value  => 'Always',
  }

  # Use function keys as standard F1, F2, etc.
  cfcc::osx_defaults { 'GlobalDomain-fnState':
    domain => 'Apple Global Domain',
    key    => 'com.apple.keyboard.fnState',
    type   => 'bool',
    value  => '1',
  }

  # Disable UI sound effects
  cfcc::osx_defaults { 'GlobalDomain-uiaudio':
    domain => 'Apple Global Domain',
    key    => 'com.apple.sound.uiaudio.enabled',
    value  => '0',
  }

  # Dock tile size
  cfcc::osx_defaults { 'Dock-tilesize':
    domain => 'com.apple.dock',
    key    => 'tilesize',
    type   => 'float',
    value  => '25',
  }

  # Dock magnification size
  cfcc::osx_defaults { 'Dock-largesize':
    domain => 'com.apple.dock',
    key    => 'largesize',
    type   => 'float',
    value  => '100',
  }

  # Auto-hide the Dock
  cfcc::osx_defaults { 'Dock-autohide':
    domain => 'com.apple.dock',
    key    => 'autohide',
    type   => 'bool',
    value  => '1',
  }

  # Disable Notes hot corner (bottom-right)
  cfcc::osx_defaults { 'Dock-wvous-br-corner':
    domain => 'com.apple.dock',
    key    => 'wvous-br-corner',
    value  => '1',
  }

  # Show Control Center items in menu bar
  cfcc::osx_defaults { 'ControlCenter-WiFi':
    domain => 'com.apple.controlcenter',
    key    => 'NSStatusItem Visible WiFi',
    type   => 'bool',
    value  => '1',
  }

  cfcc::osx_defaults { 'ControlCenter-Bluetooth':
    domain => 'com.apple.controlcenter',
    key    => 'NSStatusItem Visible Bluetooth',
    type   => 'bool',
    value  => '1',
  }

  cfcc::osx_defaults { 'ControlCenter-Battery':
    domain => 'com.apple.controlcenter',
    key    => 'NSStatusItem Visible Battery',
    type   => 'bool',
    value  => '1',
  }

  cfcc::osx_defaults { 'ControlCenter-Volume':
    domain => 'com.apple.controlcenter',
    key    => 'NSStatusItem Visible Volume',
    type   => 'bool',
    value  => '1',
  }

  # Reduce motion and transparency
  cfcc::osx_defaults { 'Accessibility-ReduceMotionEnabled':
    domain => 'com.apple.Accessibility',
    key    => 'ReduceMotionEnabled',
    value  => '1',
  }

  cfcc::osx_defaults { 'UniversalAccess-reduceMotion':
    domain => 'com.apple.universalaccess',
    key    => 'reduceMotion',
    value  => '1',
  }

  cfcc::osx_defaults { 'Accessibility-EnhancedBackgroundContrastEnabled':
    domain => 'com.apple.Accessibility',
    key    => 'EnhancedBackgroundContrastEnabled',
    value  => '1',
  }

  cfcc::osx_defaults { 'UniversalAccess-reduceTransparency':
    domain => 'com.apple.universalaccess',
    key    => 'reduceTransparency',
    value  => '1',
  }
}
