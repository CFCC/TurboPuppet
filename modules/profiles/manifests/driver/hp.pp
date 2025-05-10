#
#
#
class profiles::driver::hp {
  # HP01 is a special snowflake that has a Radeon GPU but with an Intel CPU.
  unless $facts['networking']['hostname'] =~ /(?i:cfcchp01)/ {
    include profile::driver::cpu::ryzen
  }
}
