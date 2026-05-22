#
# Tweaks to Finder and the macOS desktop environment.
#
class profiles::desktop::finder {
  # Hide widgets from the desktop
  cfcc::osx_defaults { 'WindowManager-StandardHideWidgets':
    domain => 'com.apple.WindowManager',
    key    => 'StandardHideWidgets',
    type   => 'int',
    value  => '1',
    user   => lookup('camper_username'),
  }
}
