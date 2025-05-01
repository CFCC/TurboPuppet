#
# ProduKey Windows Product Key Reporter
#
class profiles::tool::produkey {
  # #24 this is being falsely reported as a virus by Microsoft. Workarounds
  # are not fun so I'm just going to disable it until we find it is needed.
  # package { 'produkey.install': }
}
