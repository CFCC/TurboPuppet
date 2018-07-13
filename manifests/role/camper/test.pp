#
# Testing
#
class role::camper::test inherits role::base {
    # $dns_servers = ['192.168.1.103', '192.168.1.104']
    #
    # exec { 'SetDnsResolvers':
    #     command => "Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses ('${join($dns_servers, '\', \'')}')",
    #     # onlyif   => psexpr("((Get-NetConnectionProfile | select -ExpandProperty NetworkCategory) -ne 'Private')"),
    #     onlyif => psexpr("((Compare-Object (Get-DnsClientServerAddress -InterfaceAlias Ethernet -AddressFamily IPv4 | Select -ExpandProperty ServerAddresses) ('${join($dns_servers, '\', \'')}')).Length -ne 0)")
    # }

    include site::cfcc
    include profile::cfcc::camper
    include profile::access::camper

    include profile::ide::pycharm
    # include profile::python::python3
    # include profile::webservers::xampp
    #
    # windows_feature { 'Microsoft-Windows-Subsystem-Linux':
    #     ensure => absent
    # }
}
