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
}
