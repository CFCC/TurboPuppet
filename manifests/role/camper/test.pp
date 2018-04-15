#
# Testing
#
#class role::camper::test inherits role::camper::base {
class role::camper::test {
    # notify { 'Hello': }

#    exec { 'testexec':
#        command => "echo foo",
#        provider => 'powershell',
#        #onlyif => "exit [int]('Foo' -eq 'Bar')" # This is False/0
#        #onlyif => "exit [int]('Foo' -eq 'Foo')" # This is True/1
#        onlyif => "exit [int]((Get-DnsClientGlobalSetting | Select -ExpandProperty SuffixSearchList) -contains 'grantcohoe.com')"
#    }

    include profile::firewall::windows

    #warning('lolz')
}
