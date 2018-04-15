#
# Testing
#
class role::camper::test inherits role::base {
#class role::camper::test {
    # notify { 'Hello': }

    include profile::firewall::windows

    #warning('lolz')
}
