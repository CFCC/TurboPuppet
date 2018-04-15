#
# Testing
#
class role::camper::test inherits role::camper::base {
#class role::camper::test {
    # notify { 'Hello': }

    include profile::firewall::windows

    #warning('lolz')
}
