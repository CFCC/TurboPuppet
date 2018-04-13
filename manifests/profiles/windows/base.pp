#
#
#
class profiles::windows::base {
    include profiles::windows::explorer
    include profiles::windows::power
    include profiles::firewall::windows
}