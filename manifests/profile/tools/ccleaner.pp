#
# CCleaner cleanup tool
#
class profile::tools::ccleaner {
    package { 'ccleaner': }
}

# @TODO schedule runs or something